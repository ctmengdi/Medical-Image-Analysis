tic
dataDir = 'Vibot_challenge_data/';
exl = xlsread('Vibot_challenge_data/vibot_cahallenge_dbt.csv');
filename = [num2str(zeros(size(exl,1),1)),num2str(exl(:,1))];
labels = exl(:,3);

vecTrain = [];
labTrain = [];
label = [];
score = cell(1, size(filename,1));

for i = 1:size(filename,1)
    file = strcat(dataDir,filename(i,:),'/');
    name = dir([file, '*.dcm']);
    link=strcat(file,name.name);
    DBT = dicomread(link);
    fd = computeFeatureVector(DBT,'l');
    vecTest = fd;
    labTest = labels(i);
    for j = 1:size(filename,1)
        if j ~= i
            file = strcat(dataDir,filename(j,:),'/');
            name = dir([file, '*.dcm']);
            link=strcat(file,name.name);
            DBT = dicomread(link);
            fd = computeFeatureVector(DBT,'l');
            vecTrain = [vecTrain; fd];
            labTrain = [labTrain; labels(j)];
        end
    end
    vecTrain(isnan(vecTrain))=0;
    vecTest(isnan(vecTest))=0;

    % knnc classifier
    mdl = fitcknn(vecTrain,labTrain);
    [label(i),score{i},~] = predict(mdl,vecTest);
end


[C,order] = confusionmat(labels,label)


toc
