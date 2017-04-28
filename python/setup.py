#!/usr/bin/env python

from setuptools import find_packages, setup

with open('../README.rst') as f:
    readme = f.read()

with open('requirements.txt') as f:
    requirements = f.read()

setup(
    name='signalflow-grammar',
    version='2.9.0',
    description='SignalFx SignalFlow language grammar',
    long_description=readme,
    install_requires=requirements,
    packages=find_packages(),
    zip_safe=True,
    license='Apache Software License v2',
)
