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
    bool initImage(const uint8_t *PngBytes, const int inBytesCount, int threshold = 180,int height_up=1200, float height_down=1.8)
    {
        if (image != NULL)
        {
            delete image;
            image = NULL;
        }
        std::vector<uint8_t> buffer(PngBytes, PngBytes + inBytesCount);
        Mat img = imdecode(buffer, IMREAD_COLOR);

        image = new IMAGE(img, threshold,height_up,height_down);
        // imwrite("/data/user/0/com.example.car_controller/cache/processed.jpg", image->getImg());
        // std::vector<uint8_t> buffer2;
        // cv::imencode(".jpg", image->getImg().clone(), buffer2);
        // uint8_t *pngArray = new uint8_t[buffer2.size()];
        // std::memcpy(pngArray, buffer2.data(), buffer2.size());
        // return pngArray;
        return true;
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
                          detectStraightLines_width_threshold, detectStraightLines_line_width,contours_threshold);
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
}