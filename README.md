![Sign](https://i.imgur.com/bovh598.png)

Damn Small Vulnerable Web [![Python 3.x](https://img.shields.io/badge/python-3.x-yellow.svg)](https://www.python.org/) [![License](https://img.shields.io/badge/license-Unlicense-red.svg)](https://github.com/stamparm/DSVW/blob/master/LICENSE)
=========

**Damn Small Vulnerable Web** (DSVW) is a deliberately vulnerable web application written in under 100 lines of code, created for educational purposes. It supports majority of (most popular) web application vulnerabilities together with appropriate attacks.

![XSS](https://github.com/porec/pcc-dsvw/blob/main/images/attack.png)

Quick start
----

1. Deploy manifest file deploy/pcc-dsvw.yaml

2. Check IP address of the Node where pod have been deployed

```
kubectl get pods -n dsvw -o wide
kubectl get nodes -o wide
```

3. navigate your browser to http://Node_IP:30800

![DSVW](https://github.com/porec/pcc-dsvw/blob/main/images/options.png)
