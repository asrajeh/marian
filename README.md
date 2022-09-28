# marian
This is a quick guide for deploying Marian server with a translation model:


First you need to build Marian docker image

 - create a new folder and copy Dockerfile inside it

 - then build the image by running the following

```
docker build -t marian .
```

Then copy your model folder to your working directory.

Now you can run Marian server on port 18080 as follows: 
```
docker run --rm --gpus 1 -d -p 18080:18080 -v /<PATH_TO>/model:/model marian
```

To send a request, you need to do text preprocessing (segmentation) then send it for translation as follows:

```
python apply_bpe.py  -c /<PATH_TO>/model/$SRC$TRG.bpe < input.txt > input.bpe.txt
python client_example.py -p 18080 < input.bpe.txt | sed 's/\@\@ //g'
```

Note that we use sed command to unsegment (i.e. remove @@)

Python scrips can be installed from here:

https://raw.githubusercontent.com/rsennrich/subword-nmt/master/subword_nmt/apply_bpe.py

https://raw.githubusercontent.com/marian-nmt/marian/master/scripts/server/client_example.py
