function []=maxProjectionMultiTestBatch(n)
%load('L:\common\movies\Camille\2012\201204\120420_multiStacks_list.mat');
load('L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\List.mat');
a=length(List);
for i=1:a
    load(List{i,1});
    maxProjectionMultiTest(n);
end
end



List{1,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\30\20min\a-project.mat';
List{2,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\30\2h\a-project.mat';
List{3,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\30-wAgitation\20min\a-project.mat';
List{4,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\30-wAgitation\2h\a-project.mat';
List{5,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\32\20min\a-project.mat';
List{6,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\32\2h\a-project.mat';
List{7,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\35\20min\a-project.mat';
List{8,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\35\2h\a-project.mat';
List{9,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\40\20min\a-project.mat';
List{10,1}='L:\common\movies\Camille\2012\201205\150522_testTempAbsolue\40\2h\a-project.mat';