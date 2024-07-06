#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <detection.h>
#include <iostream>

using namespace std;
using namespace cv;
static IMAGE *image;
extern "C"
{
    // Attributes to prevent 'unused' function from being removed and to make it visible, please uncomment them :(
    //__attribute__((visibility("default"))) __attribute__((used))
    const char *version()
    {
        return CV_VERSION;
    }
    // __attribute__((visibility("default"))) __attribute__((used))
    uint8_t *initImage(const uint8_t *PngBytes, const int inBytesCount, int threshold = 180, int height_up = 1200, float height_down = 1.8)
    {
        if (image != NULL)
        {
            delete image;
            image = NULL;
        }
        std::vector<uint8_t> buffer(PngBytes, PngBytes + inBytesCount);
        Mat imgFeed = imdecode(buffer, IMREAD_COLOR);

        image = new IMAGE();
        // imwrite("/data/user/0/com.example.car_controller/cache/processed.jpg", image->getImg());
        // std::vector<uint8_t> buffer2;
        // cv::imencode(".jpg", image->getImg().clone(), buffer2);
        // uint8_t *pngArray = new uint8_t[buffer2.size()];
        // std::memcpy(pngArray, buffer2.data(), buffer2.size());
        // return pngArray;
        // if (buffer.empty())
        // {
        //     return false;
        // }
        // cv::Mat img = cv::imdecode(buffer, cv::IMREAD_COLOR);
        // if (img.empty())
        // {
        //     return false;
        // }
        int hh = imgFeed.rows;
        int ww = imgFeed.cols;
        int x = 0,
            y = 0, w = ww, h = 1200;
        rectangle(imgFeed, Point(x, y), Point(x + w, y + h), Scalar(255, 255, 255), -1);
        x = 0, y = 2000, w = ww, h = 900;
        rectangle(imgFeed, Point(x, y), Point(x + w, y + h), Scalar(255, 255, 255), -1);
        x = 0, y = 2800, w = ww, h = 800;
        rectangle(imgFeed, Point(x, y), Point(x + w, y + h), Scalar(255, 255, 255), -1);
        x = 0, y = 0, w = 2000, h = hh;
        rectangle(imgFeed, Point(x, y), Point(x + w, y + h), Scalar(255, 255, 255), -1);
        x = 3200, y = 0, w = 2000, h = hh;
        rectangle(imgFeed, Point(x, y), Point(x + w, y + h), Scalar(255, 255, 255), -1);

        std::vector<uint8_t> newBuf;
        cv::imencode(".png", imgFeed, newBuf);
        uint8_t *pngArray = new uint8_t[newBuf.size()];
        std::memcpy(pngArray, newBuf.data(), newBuf.size());
        return pngArray;
        // return hsv_image;
    }
    // __attribute__((visibility("default"))) __attribute__((used))
    bool destroyImage()
    {
        if (image != NULL)
        {
            delete image;
            image = NULL;
            return true;
        }
        return false;
    }
    // __attribute__((visibility("default"))) __attribute__((used))
    uint8_t *preprocessImage(int filterLargeContours_threshold = 10000,
                             int RefixThreholds_binary_threshold = 180,
                             int RefixThreholds_size_theshold = 10000,
                             int detectStraightLines_dilation_iterations = 5,
                             int detectStraightLines_horizontal_iterations = 17,
                             int detectStraightLines_diagonal1_iterations = 17,
                             int detectStraightLines_diagonal2_iterations = 17,
                             int detectStraightLines_area_threshold = 1000,
                             int detectStraightLines_width_threshold = 100,
                             int detectStraightLines_line_width = 25,
                             bool contours_threshold = false)
    {
        image->Preprocess(filterLargeContours_threshold, RefixThreholds_binary_threshold, RefixThreholds_size_theshold, detectStraightLines_dilation_iterations,
                          detectStraightLines_horizontal_iterations, detectStraightLines_diagonal1_iterations, detectStraightLines_diagonal2_iterations, detectStraightLines_area_threshold,
                          detectStraightLines_width_threshold, detectStraightLines_line_width, contours_threshold);
        std::vector<uint8_t> buffer;
        cv::imencode(".png", image->getTempImg(), buffer);
        uint8_t *pngArray = new uint8_t[buffer.size()];
        std::memcpy(pngArray, buffer.data(), buffer.size());
        return pngArray;
        // std::vector<uint8_t> buffer;
        // cv::imencode(".png", image->getImg(), buffer);
        // uint8_t *pngArray = new uint8_t[buffer.size()];
        // std::memcpy(pngArray, buffer.data(), buffer.size());
        // return pngArray;
    }
    int speedUp(const uint8_t *PngBytes, const int inBytesCount)
    {
        vector<uint8_t> buffer(PngBytes, PngBytes + inBytesCount);
        if (buffer.empty())
        {
            return -2;
        }
        cv::Mat img = cv::imdecode(buffer, cv::IMREAD_COLOR);
        if (img.empty())
        {
            return -1;
        }
        return image->speedUp(img);
    }
}