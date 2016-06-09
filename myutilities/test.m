flag = r(:, 1) > 0;
r(flag, 1) = -1;
r(~flag, 1) = 1;

[tp, fp] = roc(r(:,1), r(:,2));
auroc(tp, fp);
figure;
plot(fp, tp, 'bs -');
xlabel('False Positive Rate', 'FontSize', 16);
ylabel('Sensitivity', 'FontSize', 16);
title('AUC=0.9235', 'FontSize', 16);
grid on;
