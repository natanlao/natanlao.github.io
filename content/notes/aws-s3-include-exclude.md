+++
title = "`aws s3` `--include`, `--exclude` not working"
date = "2021-10-21"
+++

It turns out that the order of the `--exclude` and `--include` flags passed to
`aws s3 sync` and `aws s3 cp` matters, so

```
aws s3 sync 's3://my-bucket' . --include '*.png' --exclude '*'
```

won't download anything but

```
aws s3 sync 's3://my-bucket' . --exclude '*' --include '*.png'
```

will download all PNGs in the "root" of the bucket.
