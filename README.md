# Singer Voice Tester (SVT)

Singer Voice Tester (SVT) is a software application for analyzing singing voices and testing vocal skills.  
The program allows users to determine their singing voice type, analyze vocal range, and evaluate practical singing accuracy based on pitch and range.

SVT is part of the Intontrainer project:  
https://intontrainer.by/

---

## Installation

Currently on our website (see https://intontrainer.by ) the SRM prototype is uploaded, available for free download.

---

## Overview

Singer Voice Tester analyzes a sufficiently long fragment of singing (about 10 seconds) and builds a histogram of the fundamental frequency (F0) distribution across a musical scale spanning four octaves.

Based on this analysis, SVT operates in two main modes:

- singing voice type identification;
- practical singing skills testing in a game-based mode.

The application is implemented as a standalone desktop program for Windows 7 / 8 / 10.

---

## Features

### Voice Type Identification

SVT determines the user's singing voice type based on pitch distribution and vocal range.

Supported voice types:

Male voices
- Bass
- Baritone
- Tenor

Female voices
- Contralto
- Mezzo-soprano
- Soprano

The analysis result includes:
- degrees of belonging to each voice type;
- a pitch frequency histogram;
- a virtual piano keyboard covering three octaves.

To account for overlapping vocal ranges:
- male voices use the great, small, and first octaves;
- female voices use the small, first, and second octaves.

---

### Practical Singing Skills Testing

In this mode, SVT evaluates how accurately a user reproduces a reference vocal performance.

The comparison is performed by two key parameters:
- voice pitch
- vocal range

Results are visualized using a voice target:
- X-axis — deviation in vocal range (narrower / wider);
- Y-axis — deviation in pitch (lower / higher).

Evaluation is performed on a 10-point scale:
- 10 — perfect match with the reference performance;
- 0 — deviation exceeds the allowed threshold.

The permissible deviation in pitch and range is configurable by the user (measured in musical notes).

---

## Build from source

Use QT Creator or CMake to build Singer Voice Meter.
You need to build Inton Core library first.

```bash
git clone https://github.com/zhitko/singer-voice-tester.git

cd singer-voice-meter
git clone https://github.com/zhitko/inton-core.git

cmake --build . --target all
```

---

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

---

## Collaboration with RonikaLAB

The Singer Voice Tester (SVT) project was created with the participation of [RonikaLAB](https://ronikalab.by/) music studio.

The application is used in [RonikaLAB’s vocal training programs](https://ronikalab.by/uroki-vokala/) to help students:

- determine their singing voice type;
- analyze vocal range;
- track progress in pitch accuracy and range development.

---

## Authors

Development:
* [Zhitko Vladimir](https://www.linkedin.com/in/zhitko-vladimir-92662255/)

Scientific:
* [Boris Lobanov](https://www.linkedin.com/in/boris-lobanov-50628384/)

---

## License
[MIT](https://choosealicense.com/licenses/mit/)
