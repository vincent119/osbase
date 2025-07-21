#FROM public.ecr.aws/ubuntu/ubuntu:22.04_stable
FROM docker.io/library/ubuntu:latest AS base

ENV TZ=Asia/Taipei
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive
ARG EC2_KEY
ARG KUBECTL_CONFIG
ARG ECR_URL
ARG AWS_DEFAULT_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG ECR_URL

RUN apt upgrade -y && apt-get update && apt-get install -y curl sudo telnet gnupg net-tools ca-certificates jq \
    htop iputils-ping dnsutils unzip locales openssh-server openssh-client rsync git \ 
    libcap2-bin libpcap-dev \
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sudo sh ./get-docker.sh \
    && docker -v \
    &&  apt-get -y install tzdata \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update && apt-get install -y amazon-ecr-credential-helper

RUN useradd -m gitlab-runner

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    &&  unzip awscliv2.zip && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    &&  aws --version \
    && rm -rf ./aws  awscliv2.zip

RUN sudo mkdir -p ~/.ssh && sudo  touch ~/.ssh/id_ed25519 && sudo touch ~/.ssh/known_hosts && touch ~/.ssh/config \
    && echo -n "${EC2_KEY}" | base64 -d >  ~/.ssh/id_ed25519 
    #&& ssh-keyscan ${GITLAB_URL} >> ~/.ssh/known_hosts 
RUN echo -e "Host *\\n\\tStrictHostKeyChecking no\\n\\n" > ~/.ssh/config \
    && chmod 400 ~/.ssh/* \
    && eval "$(ssh-agent -s)"

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin \
    && mkdir -p ~/.kube \
    && echo -n "${KUBECTL_CONFIG}" | base64 -d > ~/.kube/config \
    && aws configure set region ${AWS_DEFAULT_REGION} --profile default \
    && aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} \
    && aws configure set aws_secret_access_key  ${AWS_SECRET_ACCESS_KEY} \
    && mkdir -p  /root/.docker \
    && aws ecr get-login-password --region ${AWS_DEFAULT_REGION}  | docker login ${ECR_URL} --username AWS --password-stdin

#RUN export vault_jwt_headers='X-Vault-Request: true' \
#    && result=$(curl -X PUT -H 'Content-Type: application/json' -d '{"jwt": "'"$CI_JOB_JWT"'", "role": "gitlab_ci_cd"}' https://vault.v16cp.me/v1/auth/jwt/login) \
#    && VAULT_TOKEN=$(echo $result | jq -r ".auth.client_token") \
#    && echo $result \
#    && echo $VAULT_TOKEN




















