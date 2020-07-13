clear all;

section_list = [];
section_y_list = [];
% 黄金率
GOLDEN_RATIO = 1.6180339887498948482045868343656;
% 初期点
a = -50;
b = 100;

% 内分点の決定
x1 = (a-b)/(GOLDEN_RATIO + 1.0) + b;
x2 = (a-b)/GOLDEN_RATIO + b;
% y 
fa = f(a);
fb = f(b);
f1 = f(x1);
f2 = f(x2);

% Save
section = [a,b,x1,x2];
section_y = [fa, fb, f1, f2];
section_list = vertcat(section_list, section);
section_y_list = vertcat(section_y_list, section_y);

% ------------------------------------------------%
while 1
    %ループを回して両点を更新
    if f1 < f2
        a = x2;
        x2 = x1;
        f2 = f1;
        x1 = (a - b)/(GOLDEN_RATIO + 1.0) + b;
        f1 = f(x1);
    else
        b = x1;
        x1 = x2;
        f1 = f2;
        x2 = (a - b)/GOLDEN_RATIO + b;
        f2 = f(x2);
    end
    section = [a,b,x1,x2];
    section_y = [fa, fb, f1, f2];
    section_list = vertcat(section_list, section);
    section_y_list = vertcat(section_y_list, section_y);

    %収束判定
    if abs(a-b)<=10^-3
        minX=(a+b)/2;
        minY=f((a+b)/2);
        break
    end
end
% ------------------------------------------------%


% ------------------------------------------------%
x = [-50:1:100];
fx = 0.01 * (x - 5).^2 + 10;

figure(1);
plot(x, fx);hold on;
p1 = plot(section_list(1,1), section_y_list(1,1) , 'o', 'MarkerSize' ,10, 'MarkerFaceColor', 'b');hold on;
p2 = plot(section_list(1,2), section_y_list(1,2) , 'o', 'MarkerSize' ,10, 'MarkerFaceColor', 'r');hold on;
hold off;
xlim([-50, 100]);
ylim([0, f(100)]);
grid on;

filename = 'sample.gif'; % Specify the output file name
frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
tmp = frame2im(frame); % 画像に変更
[A,map] = rgb2ind(tmp,256); % RGB -> インデックス画像に
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.5);

% % Animation loop -- (3)
for i = 1 : length(section_list)
    title(["Number of trials : ", num2str(i)]);
    p1.XData = section_list(i, 1);
    p1.YData = f(section_list(i,1));

    p2.XData = section_list(i, 2);
    p2.YData = f(section_list(i,2));

    drawnow;

    frame = getframe(gcf); % Figure 画面をムービーフレーム（構造体）としてキャプチャ
    tmp = frame2im(frame); % 画像に変更
    [A,map] = rgb2ind(tmp,256); % RGB -> インデックス画像に
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.5);% 画像をアペンド
end
str1 = 'Min' ;
str2 = ['x : '  num2str(minX)] ;
str3 = ['y : '  num2str(minY)] ;

text(minX-20, minY+20, str1);
text(minX-20, minY+15, str2);
text(minX-20, minY+10, str3);

function y = f(x)
%目的関数
y = 0.01 * (x - 5)^2 + 10;
end