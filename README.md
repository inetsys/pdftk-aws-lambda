# PDFtk

[PDFtk Server](https://www.pdflabs.com/tools/pdftk-server/) is a command-line tool for working with PDFs.

This project shows how to compile and deploy the `pdftk` binary as an AWS Lambda Layer, as well as a built version for the binaries ready to use.

Currently the included binaries under `bin` and `lib` were built for the **PDFtk 2.02** version.

# AWS Lambda Layer

[Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html) is a new convenient way to manage common dependencies between different Lambda Functions.

The following command will create a well-structured layer of this package:

```cmd
git clone https://github.com/inetsys/pdftk-aws-lambda.git
cd pdftk-aws-lambda
make
```

The resulting ZIP file `pdftk-aws-lambda.zip` can be uploaded to the AWS Lambda Layers console.

## Build binary

In order to compile the `pdftk` binary, the following steps were followed:

1. Start an EC2 instance with CentOS 6. Amazon Linux is not suitable as it has not the _gcj_ compiler ([see AWS Forum post](https://forums.aws.amazon.com/thread.jspa?threadID=96919))
2. Install some devtools, download the PDFtk source and build the binaries

```cmd
sudo yum update -y
sudo yum install gcc gcc-java libgcj libgcj-devel gcc-c++ wget unzip
curl -SsLO https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-src.zip
unzip pdftk-2.02-src.zip
cd pdftk-2.02-dist/pdftk
make -f Makefile.Redhat
sudo make -f Makefile.Redhat install
```

This process outputs two files:

1. The main binary file is located at `/usr/local/bin/pdftk`
2. A shared library at `/usr/lib64/libgcj.so.10` that must be copied at some location defined in the environment variable **LD_LIBRARY_PATH**

According to [AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html), there are two paths exported as environment variables directly related to AWS Lambda Layers (as they unzip under `/opt`)

* **LD_LIBRARY_PATH** includes `/opt/lib`
* **PATH** includes `/opt/bin`

The ZIP file resulting from executing `make` in this package will store both binary files under the corresponding directories, so it is ready to use system wide.

### Usage

The Layer is independent from the Lambda Function Runtime, so it should be available for any of them.
