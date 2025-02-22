# Задача

Сервис, распознающий с помощью нейросети схему помещения и возвращающий для стен, оконных и дверных проемов условные координаты, по которым возможно смоделировать указанное помещение в 3D-графических редакторах.

# Исследование

Предметная область исследования не является актуальной или широко распространенной. В 2019 году группа ученых из университета Гонг-Конга представило [обзорную статью](https://arxiv.org/pdf/1908.11025v1) по теме, где описали несколько подходов по решению задачи оптического распознавания параметров помещения по изображениям. К статье прилагается ["наглядное пособие"](https://github.com/zlzeng/DeepFloorplan) - набор инструментов и описание, как обучалась модель. Требует морально устаревшего Python2.7, что еще преодолимо, и [CUDA](https://ru.wikipedia.org/wiki/CUDA) 9 версии[^1], что уже вызывает серьезные *backwards compatibility problem*. Пособие это настолько наглядное, что в качестве материалов для обучения предоставляется целых **три** изображения. Есть ссылка на заранее предобученную модель, однако по ссылке нас ожидает лишь печальное 404.

# Практическая реализация

Заказчиком предоставлена в качестве рефренсов [выборка](https://github.com/search?q=FloorPlan+Recognition&type=repositories&p=1) репозиториев по теме распознавания схем помещения.

1) https://github.com/zcemycl/PyTorch-DeepFloorplan и https://github.com/zcemycl/TF2DeepFloorplan представляют собой фактически один и тот же проект с той разницей, что первый реализован с помощью Tensorflow, а второй - с помощью Tensorflow2. Из сложностей - фактически не поставляются с готовыми пре-тренированными моделями, требуют самостоятельной тренировки.
2) https://github.com/RasterScan/Floor-Plan-Recognition - проект с закрытым исходным кодом, с него все начиналось. Заказчика не устраивает по причине как раз закрытости исходников и невозможности прогнозирования стабильной работы.
3) https://github.com/whchien/deep-floor-plan-recognition - готовое веб-приложение. Но для его работы нужна готовая претренированная модель, которая по предоставленной ссылке отсутствует. С предоставлением другой модели работоспособность не добавилась, поскольку неизбежно возникает ошибка Tensorflow:
```python
Unsuccessful TensorSliceReader constructor: Failed to find any matching files for floor_plan_model/model/G
```
Характер ошибки свидетельствует о том, что, скорее всего, передан неподходящий формат модели, однако нельзя исключать, что изначально проект был... не вполне рабочий. В файле [deep-floor-plan-recognition/api/model_initializer.py](./deep-floor-plan-recognition/api/model_initializer.py) на 10 строке имя класса указано с ошибкой, поскольку указанный класс импортирован как `DeepFloorplanModel` из [deep-floor-plan-recognition/deepfloor/net.py](./deep-floor-plan-recognition/deepfloor/net.py), класс под названием `deepfloorplanModel` в проекте в принципе отсутствует (исправление этой ошибки не влияет на возникновение ошибки TensorFlow).

В файле [deep-floor-plan-recognition/api/system_state.py](./deep-floor-plan-recognition/api/system_state.py) есть некая переменная `path_weights` со значением `'floor_plan_model/model/G'`, однако это явно вступает в противоречие с [README.md](./README.md), где явно указано, что модель нужно поместить в директорию `deepfloor/pretrained`. 

Вариант "положить модель в `floor_plan_model/model/` и назвать ее `G` тестировался, к положительному результату не привел.

В итоге - очередное не до конца завершенное решение, которое, в отсутствие нормальной истории разработки и описания, повторить и/или исправить не представляется возможным.

4) https://github.com/nickorzha/architecture-floorplan-automatic - реализация на Kotlin, не на Python.

5) https://github.com/TINY-KE/FloorPlanParser - тоже попытка изготовления коммерческого решения, как в п.2, только эта уже не работает. Исходников нет.

6) https://github.com/maikpaixao/deep-floorplan-recognition и https://github.com/krevas/FloorPlanRecognition - по сути однотипные форки ["оригинального репозитория"](https://github.com/zlzeng/DeepFloorplan), только в первом предлагается загрузить предобученную модель самостоятельно (по той же самой 404 ссылке), а во втором она уже находится в репозитории (эта же модель встречается и [здесь](https://gitlab.com/maikpaixao/floor-detection/-/blob/master/download.sh), из чего следует, что модель как таковая существует одна и ходит по интернету, появляясь в разных местах). Как и оригинал, требуют Python2.7 и CUDA 9 версии. Возможна попытка имплементации на удаленном хосте с GPU и предустановленным соответствующим ПО, но успех не гарантирован.

7) https://github.com/syoi92/demo-fpnet - чья-то неудачная поделка. Фактически не работает, не содержит сколь-либо вменяемых исходников, ссылается на [другой репозиторий](https://github.com/streamlit/demo-face-gan.git), в котором тоже битые зависимости, в связи с чем он не устанавливается.

8) https://github.com/Menglinucas/Floorplan-recognition - суть проекта не совсем ясна, какое он имеет отношение к распознаванию схем, тоже. Возможно, это чей-то промежуточный результат, личный, в котором нет ни списка зависимостей (инструментов), ни внятной инструкции по использованию.

9) https://github.com/mmatosin/floorplan-recognition-test - реализация на языке Lua.

10) https://github.com/MaclaurinSeries/floorplan-recognition-website - принцип работы приложения неясен, запустить его не удалось, при каждой попытке запуска происходила попытка загрузки AI-модели, которая заканчивалась `ConnectionResetError: [Errno 104] Connection reset by peer`.

11) https://github.com/andreagemelli/Floorplan-Text-Detection-and-Recognition - утилита ориентирована на распознавание текста на схемах.

12) https://github.com/unrlight/InteractiveArchVizWithFloorplanRecognition - фактически некая демонстрация работы некого сервиса AR-3D-моделирования, к запросу заказчика не имеет отношения.

Самостоятельно найденное решение.

13) https://gitlab.com/maikpaixao/floor-detection/-/tree/master - самостоятельно найденное решение. [Оно же](https://colab.research.google.com/drive/1bfq2cT0AGZrMzegs-9kVM8GRIOsWOK4C?usp=sharing#scrollTo=RBRMqUqfglni) в Google Collab. 

Использует для реализации функционала оптического зрения [библиотеку Mask_RCNN](https://github.com/matterport/Mask_RCNN), которая рассчитана на работу Tensorflow первой версии и устаревшей CUDA 9. С Tensorflow проблема заключается в том, что его первая версия несовместима с современными версиями CUDA. Поэтому либо даунгрейд CUDA (что технически затруднительно), либо апгрейд Tensorflow. 

Есть [форк](https://github.com/lrpalmer27/Mask-RCNN-TF2/) этой библиотеки под Tensorflow2, но само решение все равно использует функционал устаревшей версии библиотеки [Keras](https://ru.wikipedia.org/wiki/Keras), поэтому требует очень глубокой переработки. 

Существует [попытка](https://github.com/Rial-Ali/Mask_RCNN/blob/edit-requirements/requirements.txt) обойти эту проблему, втиснувшись в узкий промежуток зависимостей, но, опять же, она не позволяет избежать конфликта совместимости: старые версии Tensorflow (обеих мажорных версий, 1 и 2) несовместимы с современной версией CUDA (12.4), максимум, до которого удалось подтянуть зависимости - это CUDA 10, но возникли проблемы аппаратного характера, поэтому см. п. 6 про удаленный хост с GPU.

# Вывод

Наиболее "быстрым" с точки зрения реализации, является использование [открытого API](https://github.com/RasterScan/Floor-Plan-Recognition). Останется только преобразовать координаты в желаемый формат. Из минусов - негарантированный догий срок жизни чужого API.

Избежать этого поможет выбор долгого, длинного, а самое главное дорогого с точки зрения оплаты труда специалистов пути - последовательно повторить шаги авторов оригинальной статьи или переписать и актуализировать с точки зрения применяемых технологий [чужое оригинальное решение](https://gitlab.com/maikpaixao/floor-detection/-/tree/master). Обязательной оговоркой в этом случае является также то, что данные решения вовсе *не гарантируют* возврата готового результата в виде координат. Вполне вероятным является вариант, при котором полученные в результате анализа результаты потребуют длительного и сложного алгоритмического их анализа с целью приведения к желаемому результату.

Сами модели и используемые веса находятся [здесь](https://disk.yandex.ru/d/KdoBC_FR9qigKQ).

[^1]: На момент написания текста актуальная версия CUDA - 12.4.
