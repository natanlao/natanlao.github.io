+++
title = "AWS ECR `docker push` fails with EOF"
date = "2022-03-17"
+++

If you're pushing a Docker image to an AWS Elastic Container Registry
repository and you encounter an EOF error:

```
$ docker push ${ECR_ID}.dkr.ecr.us-east-1.amazonaws.com/${IMAGE}:latest
...
6d6356604420: Layer already exists
c2dc8b8960d7: Layer already exists
EOF

$ journalctl -u docker.service
...
Mar 17 15:02:06 hostname dockerd[16882]: time="2022-03-17T15:02:06.394662889-04:00" level=error msg="Upload failed, retrying: EOF"
...
Mar 17 15:23:58 hostname dockerd[17716]: time="2022-03-17T15:23:58.438706900-04:00" level=error msg="Upload failed: EOF"
```

then check the IAM policy that is supposed to authorize you to push to your
repository, as ECR may "silently" deny unauthorized pushes with an EOF. If
this is the case, you'll see an event in CloudTrail documenting that your push
was denied.

When this happened to me, it was because I had a malformed ARN for my
repository in the IAM policy I wrote. In particular, I specified

```
arn:aws:ecr:us-east-1:${ACCOUNT_ID}:${IMAGE}
```

instead of

```
arn:aws:ecr:us-east-1:${ACCOUNT_ID}:repository/${IMAGE}
```

.
