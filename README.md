# The vowstar-overlay

Shared ebuild files.

## How to add using layman

```bash
layman -a vowstar
```

Or

```bash
layman --add=vowstar
```

Or

```bash
layman -o https://raw.githubusercontent.com/vowstar/vowstar-overlay/master/metadata/vowstar.xml -f -a vowstar
```

## How to use nvidia-docker2 under gentoo

I fixed the nvidia-container-toolkit (aka. nvidia-docker2 ) issue under gentoo and got this working.

Due to historical reasons, the software supported by nvidia's docker has gone through a very messy period. About The difference between libnvidia-container, nvidia-docker2, nvidia-container-runtime, nvidia-container-toolkit, [here is a good introduction](https://github.com/NVIDIA/nvidia-docker/issues/1268).

Here only introduces how to use the new method in the Docker version after 19.03:

```bash
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
```

### OpenRC

```bash
sudo layman --add=vowstar
sudo emerge -av nvidia-container-toolkit
sudo rc-service docker restart
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
```

### systemd

```bash
sudo layman --add=vowstar
sudo emerge -av nvidia-container-toolkit
sudo systemctl restart docker
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
```

### Result

```text
$ docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
Fri Jun 12 17:23:54 2020
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.82       Driver Version: 440.82       CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce RTX 208...  Off  | 00000000:0A:00.0  On |                  N/A |
|  0%   51C    P0    62W / 300W |   1413MiB / 11016MiB |      8%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+

$ uname -a
Linux ryzen 5.6.17-gentoo #1 SMP PREEMPT Mon Jun 8 11:35:26 CST 2020 x86_64 AMD Ryzen 9 3900X 12-Core Processor AuthenticAMD GNU/Linux
```

## The octave-forge packages

It is generated from [https://github.com/vowstar/octave-gentoo-package](https://github.com/vowstar/octave-gentoo-package)
