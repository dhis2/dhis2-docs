from setuptools import setup

with open('README.md') as f:
    long_description = f.read()

setup(
    name='pd_attr_list',
    version='2',
    description= 'Parse markdown attributes like pandoc',
    url='',
    author='philld',
    author_email='phil@dhis2.org',
    license='BSD3',
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=['pd_attr_list'],
    keywords="markdown pandoc attributes",
    install_requires=['Markdown>=3.0.1'],
    classifiers=[
        'Development Status :: 4 - Beta', 'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Operating System :: OS Independent', 'Programming Language :: Python',
        'Topic :: Text Processing :: Markup :: HTML'
    ])
