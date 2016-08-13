# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM java:8

MAINTAINER Toshihiro.Kamada <tshrkmd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.1,android-19,android-23,android-24
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository
ENV GOOGLE_EMULATOR sys-img-armeabi-v7a-android-19
ENV GOOGLE_EMULATOR_PREVIEW sys-img-armeabi-v7a-android-24

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}"
RUN echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"
RUN echo y | android update sdk --no-ui --all --filter "${GOOGLE_EMULATOR}"
RUN echo y | android update sdk --no-ui --all --filter "${GOOGLE_EMULATOR_PREVIEW}"

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx512m

# Set up and run emulator
RUN echo no | android create avd -f -n android-19-v7a -t android-19 -s HVGA

# WORKSPACE
VOLUME /workspace
WORKDIR /workspace
