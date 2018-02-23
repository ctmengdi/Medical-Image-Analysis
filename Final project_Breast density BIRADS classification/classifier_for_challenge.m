tic
dataDir = 'Vibot_challenge_data/';
exl = xlsread('Vibot_challenge_data/vibot_cahallenge_dbt.csv');
filename = [num2str(zeros(size(exl,1),1)),num2str(exl(:,1))];
labels = exl(:,3);

dataDir2 = 'Vibot_challenge_test_data/';
[exl2,text] = xlsread('Vibot_challenge_test_data/Vibot_test_data.csv');
filename2 = [num2str(zeros(size(exl2,1),1)),num2str(exl2(:,1))];
text = cell2mat(text);

vecTrain = [];
labTrain = [];

% Training dataset
for i = 1:size(filename,1)
    file = strcat(dataDir,filename(i,:),'/');
    name = dir([file, '*.dcm']);
    link=strcat(file,name.name);
    DBT = dicomread(link);
    fd = computeFeatureVector(DBT,'l');
    vecTrain = [vecTrain; fd];
    labTrain = [labTrain; labels(i)];
    
    vecTrain(isnan(vecTrain))=0;
end

vecTest = [];
% Testing dataset
for j = 1:size(filename2,1)
    file = strcat(dataDir2,filename2(j,:),'/');
    name = dir([file, '*.dcm']);
    link=strcat(file,name.name);
    DBT = dicomread(link);
    fd = computeFeatureVector(DBT,text(j));
    vecTest = [vecTest; fd];
    
    vecTest(isnan(vecTest))=0;   
end

mdl = fitcknn(vecTrain,labTrain);
[label,score,cost] = predict(mdl,vecTest)


toc
