 gamma1, gamma2, gamma3 = 2.0, 3.0, 0.5
 og1, og2, og3 = 1-gamma1, 1-gamma2, 1-gamma3
 w1, w2, w3 = 1.0, 2.0, 3.0
 p1, p2, p3 = 1.0, 1.0, 1.0
 I = 100.0


function u(c, gamma)
   og = 1-gamma
   return c^og/og
end
 
 
function du(c, gamma)
   return c^(-gamma)
end


function du2(c,gamma)
   return -gamma * c^(-gamma-1)
end


function unpack_consumption(c)
   c1 = c[1]
   c2 = c[2]
   c3=   (I-p1*c1-p2*c2)/ p3  
   return c1, c2, c3
end  


function neg_objective(c)
   c1, c2, c3 = unpack_consumption(c)
   objective=  w1*u(c1,gamma1) + w2*u(c2,gamma2) + w3*u(c3,gamma3)
   return -objective
end


function neg_gradient(c)
   c1, c2, c3 = unpack_consumption(c)
   gradient = zeros(2)
   temp = w3*du(c3,gamma3)
   gradient[1] = w1*du(c1,gamma1) - temp*(p1/p3)
   gradient[2] = w2*du(c2,gamma2) - temp*(p2/p3)
   return - gradient
end  


function neg_hessian(c)
   c1, c2, c3 = unpack_consumption(c)
   hessian = zeros(2,2)
   temp2 = w3*du2(c3,gamma3)
   hessian[1,1] =  w1*du2(c1,gamma1) + temp2*(p1/p3)^2
   hessian[2,2] =  w2*du2(c2,gamma2) + temp2*(p2/p3)^2
   hessian[1,2] = temp2*(p1/p3)*(p2/p3)
   hessian[2,1] = hessian[1,2]
   return -hessian
end   


test = [ 1.0 ;  2.0];

f = neg_objective(test)
g = neg_gradient(test)
h = neg_hessian(test)



function newton(fun, grad, hess, x, tol)
   xbar = x 
   x = x + 2*tol
   iter = 0
   maxit = 100
   n = size(x,1)

   while (sum(abs.(x-xbar)) > n*tol)  & (iter < maxit)
         iter = iter + 1
         xbar = x
         f,g,h = fun(xbar), grad(xbar), hess(xbar)
         x = xbar .-  h\g
         println("ITER:", iter, " ", x, " ",f)
   end

   return x
end


a = newton(neg_objective,neg_gradient,neg_hessian, test, 1e-8)
