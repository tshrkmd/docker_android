# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM java:8

MAINTAINER Toshihiro.Kamada <tshrkmd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive


# Install sudo
RUN apt-get update \
  && apt-get -y install sudo \
  && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Install 32bit lib
RUN sudo apt-get -y install lib32stdc++6 lib32z1

# Install Java8
RUN apt-get install -y software-properties-common curl \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk


# Install dependencies
# RUN dpkg --add-architecture i386 && \
#    apt-get update && \
#    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
#    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.1,android-19,android-23,android-24
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository
ENV GOOGLE_EMULATOR sys-img-armeabi-v7a-android-24,sys-img-armeabi-v7a-android-19

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}"
RUN echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"
RUN echo y | android update sdk --no-ui --all --filter "${GOOGLE_EMULATOR}"


# Set up and run emulator
RUN echo no | android create avd -f -n android-24-v7a -t android-24 -s HVGA
# RUN echo no | android create avd -f -n android-24-v7a -t android-24
RUN echo no | android create avd -f -n android-19-v7a -t android-19 -s HVGA

# RUN mkdir -p /opt/tmp && android create project -g 2.14.1 -v 2.2.+ -a MainActivity -k com.example.example -t  android-24 -p /opt/tmp
# RUN cd /opt/tmp && ./gradlew tasks
# RUN rm -rf /opt/tmp

VOLUME /workspace
WORKDIR /workspace



#mv local.properties local.properties.bk
# docker run -t -i -v `pwd`:/workspace kerukerupappa/docker-android start-emulator "./gradlew connectedAndroidTest"
#mv local.properties.bk local.properties

# docker run -t -i -v `pwd`:/workspace b7a4674f0013 emulator -force-32bit "./gradlew connectedAndroidTest"


#echo no | android create avd --force -n android-24-v7a2 -t android-24 -memory 1024
# emulator -memory 1024 -avd android-24-v7a -no-skin -no-audio -no-window -force-32bit
# emulator -memory 1024 -avd android-19-v7a -no-skin -no-audio -no-window -force-32bit -no-boot-anim
