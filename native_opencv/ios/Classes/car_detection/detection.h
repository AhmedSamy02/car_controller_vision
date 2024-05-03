#pragma once
#include <opencv2/core.hpp>
class IMAGE
{
    private:
        cv::Mat img;
        cv::Mat grey;
        cv::Mat binary;
        bool error_image;
        std::vector<cv::Point2f> output_corners;
        std::vector<cv::Point2f> corners;
        cv::Mat temp_img;
        // get rid of large contours
        void filterLargeContours(int threshold=10000);
        // fix image prespective
        void fixPrespective();
        //threshold after fixing prespective
        void RefixThreholds(int binary_threshold=180,int size_theshold=10000,bool contours_threshold=false);
        //get rid of non straight lines using moprphology
        void detectStraightLines(int dilation_iterations=5,int horizontal_iterations=17,int diagonal1_iterations=17
        , int diagonal2_iterations=17,int area_threshold=1000, int width_threshold=100, int line_width=25);
        void cropImage(int height_up=1200, float height_down=1.8, int threshold=180);
    public:
    IMAGE(cv::Mat & img, int threshold=180,int height_up=1200, float height_down=1.8);
    cv::Mat& getImg();
    cv::Mat& getGrey();
    cv::Mat& getBinary();
    cv::Mat & getTempImg();
    void Preprocess(int filterLargeContours_threshold=10000,int RefixThreholds_binary_threshold=180,int RefixThreholds_size_theshold=1000,
    int detectStraightLines_dilation_iterations=5,int detectStraightLines_horizontal_iterations=22,int detectStraightLines_diagonal1_iterations=17
        , int detectStraightLines_diagonal2_iterations=17,int detectStraightLines_area_threshold=1000, int detectStraightLines_width_threshold=100, 
        int detectStraightLines_line_width=25,bool contours_threshold=false);
};
