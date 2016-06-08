# SSLROC
SSLROC
By Shijun Wang and Ronald M. Summers. 

This reference must be cited when using this code:
Shijun Wang, Diana Li, Nicholas Petrick, Berkman Sahiner, Marius George Linguraru, and Ronald
M. Summers. Optimizing Area Under the ROC Curve Using Semi-Supervised Learning. Pattern
Recognition, vol. 48(1), pp. 276-287, 2014.


Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following condition is met:

Redistributions of must retain this file, including this list of conditions and the following warranty disclaimer.

NO WARRANTY
THIS SOFTWARE IS PROVIDED BY THE AUTHORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR THEIR EMPLOYERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


The minimum Matlab version required to run this package is Matlab version 7.12.0.0635 (R2011a).

Function experiment(method, dataset, P1, P2) is the main function of this package.
Input parameter:
method: ROC optimization method to be tested.
dataset: designate which dataset will be used for the testing.
P1 and P2: parameter used by the method tested.

Output
Test results will be saved in the following file:
[name_method '/' Para.Global.name '_AUC_' name_method '_P1_' str1 '_P2_' str2].txt

The proposed method for ROC optimization using semi-supervised learning is 
function [d_double, output] = ROC_SSL(Y_training, X_training, X_test, para)
Input parameters:
Y_training: labels of training samples
X_training: features of training samples
X_test: features of test samples with unknown labels
para: parameters used to tune the performance of SSLROC algorithm

Data Format:
Data set to be tested was pre-processed and stored in a Matlab *.dat data file. It contains X_ori and Y_ori, which corresponds to feature set and label set, respectively. Then we employ cross-validation method to split them into training and testing sets.

To run the package the compare the performance of SSLROC with other state-of-the-art ROC optimization methods, you may need to download the following third-party packages:
LIBSVM: 
https://www.csie.ntu.edu.tw/~cjlin/libsvm/
Semi-supervised RankBoost for bipartite Ranking:
http://www-connex.lip6.fr/~amini/SSRankBoost/
 
CSDP, A C Library for Semidefinite Programming:
https://projects.coin-or.org/Csdp
OPAUC:
http://lamda.nju.edu.cn/code_OPAUC.ashx?AspxAutoDetectCookieSupport=1
SDPT3 version 4.0 -- a MATLAB software for semidefinite-quadratic-linear programming:
http://www.math.nus.edu.sg/~mattohkc/sdpt3.html
SeDuMi:
http://sedumi.ie.lehigh.edu/
SVM and Kernel Methods Matlab Toolbox:
http://asi.insa-rouen.fr/enseignants/~arakoto/toolbox/
YALMIP:
http://users.isy.liu.se/johanl/yalmip/
