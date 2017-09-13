/*
 * Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef _AD_INFO_H
#define _AD_INFO_H

#include <QStringList>

#ifdef QTADMOB_QML
    #ifdef ENABLE_REAL_ADS
        #define BANNER_ID        "ca-app-pub-5828460259173662/2959223234"
        #define INTERSTITIAL_ID  "ca-app-pub-5828460259173662/4859337768"
    #else
        #define BANNER_ID        "ca-app-pub-3940256099942544/6300978111"
        #define INTERSTITIAL_ID  "ca-app-pub-3940256099942544/1033173712"
    #endif
#else
    #define BANNER_ID            ""
    #define INTERSTITIAL_ID      ""
#endif

#endif
