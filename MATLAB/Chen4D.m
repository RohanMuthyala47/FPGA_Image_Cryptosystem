function [X_keys, Y_keys, Z_keys, W_keys, X_full, Y_full, Z_full, W_full] = Chen4D(...
    X_Initial, Y_Initial, Z_Initial, W_Initial, ...
    alpha, gamma, epsilon, beta, lambda, h, N)
    
    % Pre-allocate arrays
    X_full = zeros(1, N);
    Y_full = zeros(1, N);
    Z_full = zeros(1, N);
    W_full = zeros(1, N);
    
    % Set initial conditions
    X_full(1) = X_Initial;
    Y_full(1) = Y_Initial;
    Z_full(1) = Z_Initial;
    W_full(1) = W_Initial;
    
    % RK4 iterations
    for i = 1:N-1
        % k1 slopes
        m1 = h * F(X_full(i), Y_full(i), W_full(i), alpha);
        l1 = h * G(X_full(i), Y_full(i), Z_full(i), gamma, epsilon);
        o1 = h * R(X_full(i), Y_full(i), Z_full(i), beta);
        p1 = h * S(Y_full(i), Z_full(i), W_full(i), lambda);
        
        % k2 slopes
        m2 = h * F(X_full(i) + m1/2, Y_full(i) + l1/2, W_full(i) + p1/2, alpha);
        l2 = h * G(X_full(i) + m1/2, Y_full(i) + l1/2, Z_full(i) + o1/2, gamma, epsilon);
        o2 = h * R(X_full(i) + m1/2, Y_full(i) + l1/2, Z_full(i) + o1/2, beta);
        p2 = h * S(Y_full(i) + l1/2, Z_full(i) + o1/2, W_full(i) + p1/2, lambda);
        
        % k3 slopes
        m3 = h * F(X_full(i) + m2/2, Y_full(i) + l2/2, W_full(i) + p2/2, alpha);
        l3 = h * G(X_full(i) + m2/2, Y_full(i) + l2/2, Z_full(i) + o2/2, gamma, epsilon);
        o3 = h * R(X_full(i) + m2/2, Y_full(i) + l2/2, Z_full(i) + o2/2, beta);
        p3 = h * S(Y_full(i) + l2/2, Z_full(i) + o2/2, W_full(i) + p2/2, lambda);
        
        % k4 slopes
        m4 = h * F(X_full(i) + m3, Y_full(i) + l3, W_full(i) + p3, alpha);
        l4 = h * G(X_full(i) + m3, Y_full(i) + l3, Z_full(i) + o3, gamma, epsilon);
        o4 = h * R(X_full(i) + m3, Y_full(i) + l3, Z_full(i) + o3, beta);
        p4 = h * S(Y_full(i) + l3, Z_full(i) + o3, W_full(i) + p3, lambda);
        
        % Update
        X_full(i+1) = X_full(i) + (m1 + 2*m2 + 2*m3 + m4) / 6;
        Y_full(i+1) = Y_full(i) + (l1 + 2*l2 + 2*l3 + l4) / 6;
        Z_full(i+1) = Z_full(i) + (o1 + 2*o2 + 2*o3 + o4) / 6;
        W_full(i+1) = W_full(i) + (p1 + 2*p2 + 2*p3 + p4) / 6;
    end
    
    % Convert to encryption keys
    seq = 20001 : min(N, 20000 + 256*256);
    
    Xq = floor(abs(X_full(seq)) * 1e16);
    Yq = floor(abs(Y_full(seq)) * 1e16);
    Zq = floor(abs(Z_full(seq)) * 1e16);
    Wq = floor(abs(W_full(seq)) * 1e16);
    
    X_keys = uint8(mod(Xq, 256));
    Y_keys = uint8(mod(Yq, 256));
    Z_keys = uint8(mod(Zq, 256));
    W_keys = uint8(mod(Wq, 256));
end