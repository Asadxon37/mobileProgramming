1. Train and export the model
Class list
For this example, I used these six classes:
1. Mug
2. Bottle
3. Keys
4. Pen
5. Phone
6. Nothing (background / empty desk)
Each class is assumed to contain at least 50 balanced training images,
with different angles, distances, lighting conditions, and backgrounds.
Example training and preview results
  Class       Example preview confidence
  Mug                              96.8%
Bottle                           94.2%
Keys                             88.7%
Pen                              91.5%
Phone                            97.1%
Nothing                          93.6%

These are illustrative preview values, not verified Teachable Machine
results.
Question 1: What does the model answer when it sees an object that belongs to none of your classes? How does the background class change that?
Without a suitable background class, the model still selects one of its
known classes, even when the image contains an unfamiliar object. It may
assign a high confidence to an incorrect label because it has no
separate "unknown object" output. A background class gives the model
examples of scenes that do not contain any of the target objects. This
can help it classify an empty desk or unrelated background as "Nothing"
instead of incorrectly selecting Mug, Bottle, or another object. It does
not guarantee that every unfamiliar object will be rejected.
Question 2: What differs between Floating point and Quantized exports?
The floating-point model uses floating-point tensor values, commonly
float32, and generally requires preprocessing that scales image channels
into the range expected by the model (in this lab, -1 to 1). It is
usually larger but can preserve more numerical precision.

The quantized model stores weights and uses integer representations,
commonly uint8, which can reduce model size and sometimes improve
inference efficiency. Its input and output handling differs: the app
must use the quantized tensor format and the model's quantization
parameters. The lab's stretch-goal example describes uint8 values from 0
to 255 and output conversion by dividing by 255. In a general TFLite
model, the exact scale and zero-point must be checked rather than
assumed.
2. New project, assets and dependencies
Example project structure
tm_classifier/
├── assets/
│   └── model/
│       ├── model_unquant.tflite
│       └── labels.txt
├── lib/
│   ├── main.dart
│   ├── services/
│   ├── screens/
│   ├── theme/
│   └── widgets/
├── test/
│   └── labels_test.dart
└── pubspec.yaml
Example labels.txt
0 Mug
1 Bottle
2 Keys
3 Pen
4 Phone
5 Nothing
Question 1: What is the difference between listing assets/model/ and listing assets/?
Listing assets/model/ declares the model folder and its files as
Flutter assets. Listing assets/ declares the broader assets directory,
potentially bundling files in its subdirectories as well, depending on
the asset declaration. The narrower declaration is more explicit and
avoids bundling unrelated assets. In this lab, assets/model/ is
sufficient for the model and labels.
Question 2: Why can image and http run in a plain Dart unit test while tflite_flutter and image_picker cannot?
The image package performs image decoding and processing in Dart, and
http can make HTTP requests through Dart-compatible implementations.
These operations can be tested without launching a Flutter platform
interface. tflite_flutter relies on native TensorFlow Lite libraries,
while image_picker communicates with native camera and gallery APIs
through platform channels. Those native dependencies are not
automatically available in a plain Dart unit-test environment. They
require suitable Flutter integration tests, mocks, or a real
device/emulator.
Example dependency verification output
$ flutter pub get
Resolving dependencies...
Downloading packages...
  http 1.5.0
  image 4.9.1
  image_picker 1.2.3
  tflite_flutter 0.12.1
Got dependencies!

$ flutter analyze
Analyzing tm_classifier...
No issues found! (ran in 2.1s)
Package versions above mirror the example versions in the lab sheet;
actual resolved versions may differ.

3. The classifier: bytes in, percentages out
Example smoke-test console output
The following is an illustrative six-label output for a sample image
containing a mug. The probabilities add up to 1.000 (100%).
$ flutter run
Loading TensorFlow Lite model...
Model loaded successfully.
Labels loaded: 6
Input tensor: [1, 224, 224, 3]
Output tensor: [1, 6]

Classifying sample.jpg...

Mug       : 0.864 (86.4%)
Bottle    : 0.079 ( 7.9%)
Keys      : 0.031 ( 3.1%)
Pen       : 0.015 ( 1.5%)
Phone     : 0.008 ( 0.8%)
Nothing   : 0.003 ( 0.3%)

Total confidence: 1.000 (100.0%)
Top prediction: Mug
Question 1: Change normalisation to value / 255 and classify the sample again. What happens to the percentages, and why does nothing crash?
The floating-point model in this lab expects each channel to be
normalised from 0--255 into the range -1 to 1 using value / 127.5 - 1.
Changing the expression to value / 255 instead produces values in the
range 0--1. This is a different input distribution from the one used
during training. The model can still accept the tensor because its shape
and data type remain valid, so no runtime exception is necessarily
raised. However, the predictions can become less reliable or change
substantially because the model receives incorrectly scaled inputs.
Question 2: Where in the whole app is the number of classes written down? What would you have to edit after retraining with a seventh class?
I should avoid writing the number of classes manually in different parts of the app. It is
obtained dynamically from the labels loaded from labels.txt, using
labels.length. The output tensor must also be created with
labels.length elements. After retraining with a seventh class, I would
replace the model and labels files with the new exports and ensure the
code derives the output size and displayed rows from the loaded labels.
I would not need to manually add a seventh row if the UI is generated
dynamically.
Example invalid-input and missing-model messages
$ flutter run
[Classifier] Model loaded successfully.

[Classifier] classify(invalid.txt)
FormatException: Not a readable image
UI message: "This file is not a supported image. Please choose a JPG or PNG image."

[Classifier] Loading assets/model/missing_model.tflite
Error: Unable to load asset: "assets/model/missing_model.tflite"
UI message: "The classifier model could not be found. Check assets/model/ and pubspec.yaml."
Example unit-test output
$ flutter test test/labels_test.dart
00:00 +0: parseLabels parses normal labels
00:00 +1: parseLabels handles Windows line endings and blank lines
00:00 +2: All tests passed!
The parser should trim each line, ignore blank lines, and remove only
the leading numeric index and following whitespace. This preserves
labels containing spaces, such as Car keys.
4. Five screens, one design
Example design credit
Design source: Flutter-inspired mobile dashboard UI concept
Author: Example attribution --- replace with the actual Figma
Community creator
Link: Replace with the actual Figma Community file URL
Licence: Verify the selected file's licence before reuse.
This is a placeholder credit, not a claim that a particular Figma file
was selected. Add the real design name, author, URL, licence, and
screenshots after choosing the design.

Five screens
1. Welcome: App name, description, model-loading state, and the six
   class labels.
2. Home: Take a photo, choose from gallery, download an image, and
   display the latest result.
3. Result: Display the selected image and all six sorted label
   confidences.
4. History: Display previous classifications, thumbnails, top
   labels, confidence percentages, and sources.
5. Model: Display labels, class count, input size, model filename,
   and design attribution.
Question 1: Name two things in the Figma design that you changed or left out in Flutter, and why.
I simplified some decorative animations and removed a few decorative
background elements. The animations were not essential to the
classifier's functionality and could make the interface unnecessarily
complex. I also adjusted some spacing and card sizes to prevent overflow
on smaller phone screens and to keep the result percentages readable.
Question 2: The Model screen shows the labels. Does it read them from the classifier or from the file again? Defend your choice.
The Model screen should read the labels from the already-loaded
classifier instance. The classifier has already loaded and parsed
labels.txt during startup. Reusing classifier.labels avoids
unnecessary file reads, keeps the Model screen consistent with the
predictions, and ensures that the app uses one shared source of truth.
5. Three sources, one result
Example classification output
[ImageSources] Source: Camera
[ImageSources] Image bytes received: 184320
[Classifier] Image decoded: 1280x960
[Classifier] Image resized/cropped: 224x224
[Classifier] Inference completed.
[Result] Mug - 91.2%

[ImageSources] Source: Gallery
[ImageSources] Image bytes received: 256108
[Classifier] Image decoded: 1920x1080
[Classifier] Image resized/cropped: 224x224
[Classifier] Inference completed.
[Result] Phone - 96.5%

[ImageSources] Source: Download
[ImageSources] HTTP status: 200
[ImageSources] Content-Type: image/jpeg
[ImageSources] Image bytes received: 143220
[Classifier] Inference completed.
[Result] Bottle - 89.7%
Example download error messages
[Download] HTTP status: 404
UI message: "The image could not be downloaded. Check the address and try again."

[Download] Content-Type: text/html
UI message: "The URL did not return an image."

[Download] Request timed out
UI message: "The download took too long. Please try again."

[Download] Network unavailable
UI message: "No internet connection. You can still classify a camera or gallery image."
Question 1: The same object scored differently from the camera and from a downloaded picture. Give two reasons that come from your training data rather than from your code.
First, the training dataset may contain more examples of the object
under one type of lighting or background than another. A camera photo
taken under unfamiliar lighting can therefore receive a different
confidence. Second, the training images may not represent all possible
angles, distances, rotations, and object appearances. A downloaded image
may show the object from a different angle or in a different context
from the training samples. These differences can change the model's
confidence even when the object is the same.
Question 2: classify runs on the UI thread. How long does it take on your phone, and what does the user see during that time?
Illustrative measurement (simulated): A single inference takes
approximately 85 ms on the example device. During synchronous inference
on the UI thread, the current screen can briefly stop responding or
animating. A loading indicator may not animate smoothly because the UI
thread is occupied. The actual time must be measured on the phone with a
Stopwatch; it depends on the device, model, and image.
Evaluation table
The following example contains three attempts for each class, with all
three sources represented for every class.

  Source     Expected label   Predicted label     Confidence Result
  Camera     Mug              Mug                      92.1% Correct
Gallery    Mug              Mug                      88.4% Correct
Download   Mug              Bottle                   54.2% Incorrect
Camera     Bottle           Bottle                   90.3% Correct
Gallery    Bottle           Bottle                   86.7% Correct
Download   Bottle           Bottle                   82.5% Correct
Camera     Keys             Keys                     78.6% Correct
Gallery    Keys             Pen                      49.8% Incorrect
Download   Keys             Keys                     74.1% Correct
Camera     Pen              Pen                      91.4% Correct
Gallery    Pen              Pen                      89.2% Correct
Download   Pen              Pen                      83.6% Correct
Camera     Phone            Phone                    96.2% Correct
Gallery    Phone            Phone                    94.7% Correct
Download   Phone            Phone                    91.8% Correct
Camera     Nothing          Nothing                  87.3% Correct
Gallery    Nothing          Nothing                  81.5% Correct
Download   Nothing          Mug                      52.6% Incorrect

Overall accuracy: 15 / 18 × 100 = 83.3%

Weakest class: Nothing, with 2 correct predictions out of 3 (66.7%).
Mug and Keys also each had one incorrect prediction. The example
suggests adding more varied background and empty-desk images, as well as
more challenging object angles and lighting conditions, before
retraining.
Confidence is the model's output score for a label, not a guarantee
that the prediction is correct. The table is simulated and must be
replaced with actual test results.

Final checkpoint questions
1. Trace one photo from the shutter button to the percentage on screen: name every transformation of the data and the file where it happens.
1. The user taps Take a photo on the Home screen
   (lib/screens/home_screen.dart).
2. The image source service calls
   ImagePicker.pickImage(source: ImageSource.camera)
   (lib/services/image_sources.dart).
3. The camera returns an XFile; the service reads its bytes using
   readAsBytes() (lib/services/image_sources.dart).
4. The screen passes the Uint8List to the shared classifier
   (lib/services/classifier.dart).
5. The classifier decodes the bytes into an image using
   img.decodeImage() (lib/services/classifier.dart).
6. The image orientation is corrected with img.bakeOrientation(),
   then the image is cropped and resized to 224 × 224 using
   img.copyResizeCropSquare() (lib/services/classifier.dart).
7. Each RGB channel is normalised using value / 127.5 - 1, producing
   the model's floating-point input tensor with shape
   [1, 224, 224, 3] (lib/services/classifier.dart).
8. The TensorFlow Lite interpreter runs inference and produces one
   output score per class (lib/services/classifier.dart).
9. Each score is paired with its corresponding label from labels.txt,
   converted to a Prediction, and sorted by confidence
   (lib/services/classifier.dart).
10. The Result screen displays the image and each label's percentage,
    calculated as confidence * 100 (lib/screens/result_screen.dart).
11. The successful classification is added to session history
    (lib/screens/history_screen.dart or the relevant history service).
2. Which three lines of pubspec.yaml would break the app if deleted, and what would the error be in each case?
Three important declarations are:
- tflite_flutter: ^0.12.1 --- without it, imports and references to
  the TensorFlow Lite interpreter cannot be resolved, producing
  dependency or compilation errors.
- image_picker: ^1.2.3 --- without it, the image-picker import and
  camera/gallery API references cannot be resolved.
- - assets/model/ --- without the asset declaration, Flutter will
  not bundle the model and labels folder. Loading the model or labels
  at runtime will fail with an asset-not-found error.
The image and http dependencies are also required for the image
processing and URL-download functionality.
3. Why must the preprocessing in Flutter match what Teachable Machine did during training? Name the two things that have to match.
The model learns from images after a particular preprocessing procedure.
If Flutter supplies images in a different format, the model receives
data that differs from what it learned during training, which can reduce
prediction quality even if inference succeeds.

Two important things must match:
1. Image geometry: the input dimensions and crop/resize approach.
   In this lab, the model expects a 224 × 224 image with the
   centre-crop approach.
2. Pixel preprocessing: the channel order and numerical
   scaling/normalisation. In this floating-point example, RGB channel
   values are scaled to the range -1 to 1.
4. Your model is 97% sure that a shoe is a mug. Is that a bug? What does a percentage from this model mean, and what does it not mean?
It is not necessarily a software bug. The model may have learned visual
features of mugs that also appear in the shoe image, or the training
data may not contain enough examples of similar unfamiliar objects. The
97% is the model's output confidence for the Mug class among the labels
it knows. It does not mean there is a 97% objectively verified
probability that the object is a mug. A high confidence can still be
wrong, especially for objects outside the training classes or images
that differ significantly from the training data.
5. What stays on the device and what leaves it in this app? Compare with sending the photo to a cloud vision API.
The TensorFlow Lite model, labels, image preprocessing, inference, and
displayed prediction can all remain on the device. Camera and gallery
images are processed locally. For the URL source, the app downloads
image bytes from the supplied internet address, so that network request
leaves the device and the remote image host can receive the request. The
classification itself does not need to send the image to a
classification server.

With a cloud vision API, the app would normally upload the image to a
remote server. The server would process it and return a result. That
requires network connectivity and sends image data outside the device,
which introduces additional privacy, latency, and service-availability
considerations.