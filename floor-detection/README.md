# Floor Detection
[2021/07/25: updated]

## Requirements

- Please install OpenCV 3
- Please install Python 3
- Please install Tesseract 4
- Please install tensorflow-gpu
- CUDA 9.0 installed.

## Usage

To use our code, please first download the trained models using the download.sh script, then install all dependencies using the install.sh script and run the detection by executing the run.sh script.

#### Download Models

```bash
sh download.sh
```

#### Install Dependencies

```bash
sh install.sh
```

#### Run Dection
Before executing the run.sh script, you must change the image file directory.
Just place the path inside the script after the --im_path argument.

```bash
sh run.sh
```
