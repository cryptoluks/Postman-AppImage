#!/bin/bash
# MIT License
#
# Copyright (c) 2022 Valentino Međimorec
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -eu

echo "==> Download Postman"
wget -O postman.tar.gz https://dl.pstmn.io/download/latest/linux64

echo "==> Extract Postman"
tar -xzvf *.tar.gz && rm -r *.tar.gz
PACKAGE=$(cat Postman/app/resources/app/package.json)
VERSION=$(echo "$PACKAGE" | jq -r  ".version")

# Get GitHub user and repo
GH_USER="$( echo "$GITHUB_REPOSITORY" | grep -o ".*/" | head -c-2 )"
GH_REPO="$( echo "$GITHUB_REPOSITORY" | grep -o "/.*" | cut -c2- )"
RELEASE_VERSION=$(gh api -H "Accept: application/vnd.github+json" /repos/"$GH_USER"/"$GH_REPO"/releases/latest | jq -r  ".name" | sed 's/Postman AppImage //g')

echo "$VERSION";
echo "$RELEASE_VERSION";
if [ "$VERSION" = "$RELEASE_VERSION" ]; then
    echo "false";
    echo "::set-output name=create::false"
else
    echo "true";
    echo "::set-output name=create::true"
fi
