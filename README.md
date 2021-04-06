# Text-Captcha-Reader
Digital Image Processing capstone project

Captcha_Preprocessing contains the Image preprocessing steps for the required test image. The output of this file
is the input to Captcha_Segmentation.

Captcha_Segmentation contains Image segmentation using region properties.

The characters extracted from Captcha_Segmentation is used as input to a trained neural network. The neural network is trained using
EMNIST datasets for letters. Codes in relation to the above task is in ImageProc_NN folder.
