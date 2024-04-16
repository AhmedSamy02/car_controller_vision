#include <detection.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
using namespace cv;

#include <opencv2/imgproc.hpp> // Add this line to include the necessary header for cvtColor
IMAGE::IMAGE(Mat &img, int threshold)
{
    this->img = img.clone();
    cv::cvtColor(img, grey, COLOR_BGR2GRAY);
    cv::threshold(grey, binary, threshold, 255, THRESH_BINARY);
}
Mat &IMAGE::getImg()
{
    return img;
}
Mat &IMAGE::getGrey()
{
    return grey;
}
Mat &IMAGE::getBinary()
{
    return binary;
}

void IMAGE::filterLargeContours(int threshold)
{
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(binary, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);

    std::vector<std::vector<cv::Point>> filtered_contours;
    for (size_t i = 0; i < contours.size(); ++i)
    {
        if (cv::contourArea(contours[i]) > threshold)
        {
            filtered_contours.push_back(contours[i]);
        }
    }
    temp_img = img.clone();
    cv::drawContours(temp_img, filtered_contours, -1, cv::Scalar(0, 255, 0), 3);
}
Mat &IMAGE::getTempImg()
{
    return temp_img;
}
void IMAGE::fixPrespective()
{
    int height = img.rows;
    int width = img.cols;
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(binary, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);

    std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b)
              { return cv::contourArea(a) > cv::contourArea(b); });

    std::vector<cv::Point> largest_contour = contours[0];
    double epsilon = 0.02 * cv::arcLength(largest_contour, true);
    std::vector<cv::Point> approx_polygon;
    cv::approxPolyDP(largest_contour, approx_polygon, epsilon, true);

    for (size_t i = 0; i < approx_polygon.size(); ++i)
    {
        corners.push_back(cv::Point2f(approx_polygon[i].x, approx_polygon[i].y));
    }

    output_corners = {cv::Point2f(0, 0), cv::Point2f(0, height), cv::Point2f(width, height), cv::Point2f(width, 0)};
    cv::Mat matrix = cv::getPerspectiveTransform(corners, output_corners);
    warpPerspective(grey, temp_img, matrix, cv::Size(width, height));
}
void IMAGE::RefixThreholds(int binary_threshold, int size_theshold)
{
    Mat corrected_image = temp_img.clone();
    cv::threshold(temp_img, temp_img, binary_threshold, 255, cv::THRESH_BINARY);
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(temp_img, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);

    std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b)
              { return cv::contourArea(a) > cv::contourArea(b); });

    if (!contours.empty())
        contours.erase(contours.begin());

    std::vector<std::vector<cv::Point>> filtered_contours;
    for (const auto &contour : contours)
    {
        if (cv::contourArea(contour) > size_theshold)
            filtered_contours.push_back(contour);
    }

    cv::drawContours(corrected_image, filtered_contours, -1, cv::Scalar(0, 255, 0), 3);

    cv::Mat mask = cv::Mat::zeros(temp_img.size(), CV_8UC1);
    cv::fillPoly(mask, filtered_contours, cv::Scalar(255));

    cv::bitwise_not(mask, mask);
    temp_img = mask.clone();
}
void IMAGE::detectStraightLines(int dilation_iterations, int horizontal_iterations, int diagonal1_iterations, int diagonal2_iterations, int area_threshold, int width_threshold, int line_width)
{
    cv::Mat mask1 = temp_img.clone();
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3, 3));
    Mat dilated;
    cv::dilate(mask1, dilated, kernel, cv::Point(-1, -1), dilation_iterations);
    temp_img = mask1.clone();
    cv::Mat adaptive_horizontal_kernel = cv::Mat::zeros(5, 5, CV_8U);
    adaptive_horizontal_kernel.row(2) = 1;

    // detect diagonal lines 1  /

    std::vector<std::vector<cv::Point>> contours;
    cv::Mat diagonal_kernel1 = (cv::Mat_<uchar>(3, 3) << 0, 0, 1, 0, 1, 0, 1, 0, 0);
    cv::Mat hit_or_miss_diagonal1;
    cv::dilate(dilated, hit_or_miss_diagonal1, diagonal_kernel1, cv::Point(-1, -1), diagonal1_iterations);
    cv::findContours(hit_or_miss_diagonal1, contours, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);
    std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b)
              { return cv::contourArea(a) > cv::contourArea(b); });

    if (!contours.empty())
        contours.erase(contours.begin());
    for (const auto &contour : contours)
    {
        cv::RotatedRect rotated_rect = cv::minAreaRect(contour);
        cv::Point2f vertices[4];
        rotated_rect.points(vertices);
        cv::Point2f vec1 = vertices[1] - vertices[0];
        cv::Point2f vec2 = vertices[2] - vertices[1];
        // find area using cross product
        double area = std::abs(vec1.cross(vec2));
        std::vector<cv::Point> rect_points;
        for (int i = 0; i < 4; ++i)
        {
            rect_points.push_back(vertices[i]);
        }
        if (area > area_threshold)
        {
            // Draw the rotated rectangle
            std::vector<std::vector<cv::Point>> rect_contours{rect_points};
            cv::drawContours(mask1, rect_contours, 0, cv::Scalar(255, 255, 255), line_width);
        }
    }

    // detect diagonal lines 2  \/
    contours.clear();
    cv::Mat diagonal_kernel2 = (cv::Mat_<uchar>(3, 3) << 1, 0, 0, 0, 1, 0, 0, 0, 1);
    cv::Mat hit_or_miss_diagonal2;
    cv::dilate(dilated, hit_or_miss_diagonal2, diagonal_kernel2, cv::Point(-1, -1), diagonal2_iterations);
    cv::findContours(hit_or_miss_diagonal2, contours, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);
    std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b)
              { return cv::contourArea(a) > cv::contourArea(b); });
    if (!contours.empty())
        contours.erase(contours.begin());
    for (const auto &contour : contours)
    {
        cv::RotatedRect rotated_rect = cv::minAreaRect(contour);
        cv::Point2f vertices[4];
        rotated_rect.points(vertices);
        cv::Point2f vec1 = vertices[1] - vertices[0];
        cv::Point2f vec2 = vertices[2] - vertices[1];
        // find area using cross product
        double area = std::abs(vec1.cross(vec2));
        std::vector<cv::Point> rect_points;
        for (int i = 0; i < 4; ++i)
        {
            rect_points.push_back(vertices[i]);
        }
        if (area > area_threshold)
        {
            // Draw the rotated rectangle
            std::vector<std::vector<cv::Point>> rect_contours{rect_points};
            cv::drawContours(mask1, rect_contours, 0, cv::Scalar(255, 255, 255), line_width);
        }
    }
    // detect horizontal lines
    contours.clear();
    cv::Mat hit_or_miss_horizontal;
    cv::dilate(dilated, hit_or_miss_horizontal, adaptive_horizontal_kernel, cv::Point(-1, -1), horizontal_iterations);
    cv::findContours(hit_or_miss_horizontal, contours, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);
    std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b)
              { return cv::contourArea(a) > cv::contourArea(b); });
    if (!contours.empty())
        contours.erase(contours.begin());
    for (const auto &contour : contours)
    {
        int x, y, w, h;
        cv::Rect bounding_rect = cv::boundingRect(contour);
        x = bounding_rect.x;
        y = bounding_rect.y;
        w = bounding_rect.width;
        h = bounding_rect.height;
        if (w > width_threshold)
        {
            cv::rectangle(mask1, cv::Point(x, y - 30), cv::Point(x + w, y + 30), cv::Scalar(255, 255, 255), -1);
        }
    }
    cv::bitwise_not(mask1, mask1);
    cv::bitwise_or(temp_img, mask1, temp_img);
}
void IMAGE::Preprocess(int filterLargeContours_threshold, int RefixThreholds_binary_threshold, int RefixThreholds_size_theshold,
                       int detectStraightLines_dilation_iterations, int detectStraightLines_horizontal_iterations, int detectStraightLines_diagonal1_iterations, int detectStraightLines_diagonal2_iterations, int detectStraightLines_area_threshold, int detectStraightLines_width_threshold,
                       int detectStraightLines_line_width)
{
    filterLargeContours(filterLargeContours_threshold);
    fixPrespective();
    RefixThreholds(RefixThreholds_binary_threshold, RefixThreholds_size_theshold);
    detectStraightLines(detectStraightLines_dilation_iterations, detectStraightLines_horizontal_iterations, detectStraightLines_diagonal1_iterations,
                        detectStraightLines_diagonal2_iterations, detectStraightLines_area_threshold, detectStraightLines_width_threshold, detectStraightLines_line_width);
}