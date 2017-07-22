FROM ubuntu:16.04

MAINTAINER Toshihiro.Kamada <tshrkmd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 curl unzip openjdk-8-jdk --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK_VERSION r25.2.5
RUN curl -L https://dl.google.com/android/repository/tools_${ANDROID_SDK_VERSION}-linux.zip -o tools_${ANDROID_SDK_VERSION}-linux.zip  \
    && unzip -q tools_${ANDROID_SDK_VERSION}-linux.zip -d ${ANDROID_HOME}  \
    && rm -rf tools_${ANDROID_SDK_VERSION}-linux.zip
ENV PATH ${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}

# prepare sdkmanager
RUN mkdir -p $ANDROID_HOME/licenses/ \
    && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license \
    && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license \
    && mkdir ~/.android \
    && echo "count=0" > ~/.android/repositories.cfg

# Install Android SDK components
RUN sdkmanager "tools" "platform-tools" "build-tools;25.0.3" "platforms;android-25" "extras;android;m2repository" "extras;android;m2repository" "extras;google;m2repository" "extras;google;google_play_services" "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" \
    && sdkmanager --uninstall "patcher;v4" "emulator"

# WORKSPACE
RUN mkdir /workspace
WORKDIR /workspace

