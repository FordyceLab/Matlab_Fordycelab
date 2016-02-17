taus = [10, 17.5, 25]
colors = {'r', 'm', 'g'}
xstar = 0:25:500
for i = 1:size(taus,2)
    tau = taus(i)
    yhat = [];
    for n = 1:size(xstar,2)
        yhat(n) = (weighted_reg(xstar(n), PT_centroid(2,:)', PT_all_delta(2,:)', tau))'*xstar(n);
    end
    hold on
    plot(xstar, yhat, colors{i})
end