library(fpp2)
library(seasonal)

#Set working directory
setwd("C:/Users/Caglar/Desktop/Github")

#Load raw data and convert to time series objects for income and consumption
cons = ts(scan("cons.txt"),start=1959.5,frequency=4)

#Split raw data into training and test sets
cons_train = window(cons,end=2013)
cons_test = window(cons,start=2013.25)

#Q3: Make summary statistics and plots for an initial analysis of the time series
autoplot(inc_train,series="Disposable income",xlab="Year",ylab="Million AUD")+
  autolayer(cons_train,series="Consumption expenditure") #initial plot

consumption_x11=seas(cons_train, x11="") #decomposition of consumption using X11
autoplot(consumption_x11)+
  ggtitle("X11 decomposition of Consumption")+xlab("Year")

#log transform
cons_log = c()

for (t in 1:215){
  cons_log=c(cons_log,log(cons_train[t]))
}

cons_log = ts(cons_log,start=1959.5,frequency=4)

autoplot(cons_log,series="Log consumption expenditure",xlab="Year",ylab="log Mill AUD")

#seasonal log-diff transform
cons_sld = c()

for (t in 5:215){
  cons_sld=c(cons_sld,log(cons_train[t])-log(cons_train[t-4]))
}

cons_sld = ts(cons_sld,start=1959.5,frequency=4)

autoplot(cons_sld,series="Seasonal log-diff cons. expenditure",xlab="Year")

# First difference of the log-seasonal diff
#seasonal log-diff transform
cons_fsld = c()

for (t in 2:211){
  cons_fsld=c(cons_fsld,cons_sld[t]-cons_sld[t-1])
}

cons_fsld = ts(cons_fsld)


ggtsdisplay(cons_fsld)

arima_auto=auto.arima(cons_log) #auro.arima() function gives (2,1,1)(1,1,2)
summary(arima_auto)
ggtsdisplay(residuals(arima_auto))
checkresiduals(arima_auto)

arima_manual=Arima(cons_log, order=c(2,1,1), seasonal=c(0,1,3)) #However, ggtsdisplay(cons_fsld) shows seasonal MA(3).
ggtsdisplay(residuals(arima_manual))
checkresiduals(arima_manual)
summary(arima_manual) #In fact, it has a slightly better AICc, and RMSE.

## Another way of identifying a model is having a look at theoretical ACF and PACF.
arma_acf=ARMAacf(ar=c(1.5373, -0.2917, -0.2456, 1, -1,5373, 0.2917, 0.2456), ma=c(-0.5783, 0, 0, -0,6090, 0.3521847, 0, 0, -0.1415, 0.08182945, 0, 0, 0.0244, -0.01411052), lag.max=24)
arma_pacf=ARMAacf(ar=c(1.5373, -0.2917, -0.2456, 1, -1,5373, 0.2917, 0.2456), ma=c(-0.5783, 0, 0, -0,6090, 0.3521847, 0, 0, -0.1415, 0.08182945, 0, 0, 0.0244, -0.01411052), lag.max=24, pacf=T)
par(mfrow=c(1,2), pty="s")
plot(arma_acf[-1],type="h", xlab="lags", ylab="ACF")
plot(arma_pacf,type="h", xlab="lags", ylab="PACF") # Due to too many coefficients, theoretical ACF does not make sense.

ggtsdisplay(cons_fsld) #Recall ACF and PACF of our stationerized data.
# Significant spike at lag 4 in ACF along with a decaying partial correlations of lag 4, 8 and 12.
# This points out that an MA(q) model where q is the seasonal difference would be appropriate.
# Accordingly, lets construct an ARIMA model of (0,1,0)(0,1,1).

arima_manual2=Arima(cons_log, order=c(0,1,0), seasonal=c(0,1,1))
ggtsdisplay(residuals(arima_manual2))
checkresiduals(arima_manual2) 
summary(arima_manual2) # Its fit is not better than ARIMA (2,1,1)(0,1,3) model.

# Let,s see the theoretical ACF and PACF of the model implied.
arma_acf2=ARMAacf(ma=c(0,0,0,-0.57), lag.max=24)
arma_pacf2=ARMAacf(ma=c(0,0,0,-0.57), lag.max=24, pacf=T)

ACFmanual2=Acf(cons_fsld)
PACFmanual2=Acf(cons_fsld, type=c("partial"))
par(mfrow=c(1,2), pty="s")
plot(ACFmanual2, main="")
plot(PACFmanual2, main="")

par(mfrow=c(1,2), pty="s")
plot(arma_acf2[-1],type="h", xlab="lags", ylab="ACF")
plot(arma_pacf2,type="h", xlab="lags", ylab="PACF")

## Indeed variable's ACF and PACF trends looks similar with the model implied.
#Here in this part, we will compare ARIMA(2,1,1)(0,1,3) and (0,1,0)(0,1,1).
arima_manual_fc=forecast(arima_manual, h=24)
autoplot(window(cons_log,start=2008))+
  autolayer(arima_manual_fc,series="ARIMA(2,1,1)(0,1,3)")+
  autolayer(log(cons_test),series="Consumption test set")+
  ggtitle("Model vs Test set")+
  xlab("Year")+ylab("Logarithm of consumption")

arima_manual2_fc=forecast(arima_manual2, h=24)
autoplot(window(cons_log,start=2008))+
  autolayer(arima_manual2_fc,series="ARIMA (0,1,0)(0,1,1)")+
  autolayer(log(cons_test),series="Consumption test set")+
  ggtitle("Model vs Test set")+
  xlab("Year")+ylab("Logarithm of consumption")

autoplot(window(cons_log,start=2008))+
  autolayer(arima_manual_fc,series="ARIMA (2,1,1)(0,1,3)", PI=FALSE)+
  autolayer(arima_manual2_fc,series="ARIMA (0,1,0)(0,1,1)", PI=FALSE)+
  autolayer(log(cons_test),series="Consumption test set")+
  ggtitle("Comparison of ARIMA models")+
  xlab("Year")+ylab("Logarithm of consumption")

autoplot(window(cons_log,start=2008))+
  autolayer(arima_manual_fc,series="ARIMA (2,1,1)(0,1,3)")+
  autolayer(arima_manual2_fc,series="ARIMA (0,1,0)(0,1,1)")+
  autolayer(log(cons_test),series="Consumption test set")+
  ggtitle("Comparison of ARIMA models")+
  xlab("Year")+ylab("Logarithm of consumption")
