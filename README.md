# How do I package the OpenCV library in a .zip file?
You will need to add a bunch of dependencies to use OpenCV library as AWS Lambda Layer.

1. On the local workstation (terminal window 1):
```
mkdir /tmp/opencv && cd /tmp/opencv
echo opencv-python==4.5.1.48 > ./requirements.txt
```

2. On local workstation (terminal window 2):
```
docker run -it -v /tmp/opencv:/opencv  lambci/lambda:build-python3.8 bash
```

The above command will put you into the docker container.

Inside the container:
```
cd /opencv

pip install --no-deps -t python/lib/python3.8/site-packages/ -r requirements.txt

yum install -y mesa-libGL

cp -v /usr/lib64/libGL.so.1 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGL.so.1.7.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libgthread-2.0.so.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libgthread-2.0.so.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libglib-2.0.so.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGLX.so.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libX11.so.6 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libXext.so.6 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGLdispatch.so.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGLESv1_CM.so.1.2.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGLX_mesa.so.0.0.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libGLESv2.so.2.1.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libxcb.so.1 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libXau.so.6 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /usr/lib64/libXau.so.6 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
cp -v /lib64/libGLdispatch.so.0.0.0 /opencv/python/lib/python3.8/site-packages/opencv_python.libs/
```

3. On local workstation again (terminal window 1)

Pack the python folder into `opencv.zip`.

```
zip -r -9 opencv.zip python
```

Add AWS provide `SciPy` layer `AWSLambda-Python38-SciPy1x`.
