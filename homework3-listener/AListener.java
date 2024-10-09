package com.itheima.lisenter;

import jakarta.servlet.ServletRequestEvent;
import jakarta.servlet.ServletRequestListener;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
@Slf4j
@Component
public class AListener implements ServletRequestListener {
    private long startTime;
    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();
        startTime = System.currentTimeMillis();
        String ip=request.getRemoteAddr();
        String requestMethod = request.getMethod();
        String url=request.getRequestURL().toString();
        String sessionID=request.getSession().getId();//由服务器随机生成

        log.info("前端请求的IP地址为:{} ,请求的方法为{}",ip,requestMethod);
        log.info("前端请求的URL地址为:{} ",url);
        log.info("前端请求的session id地址为:{} ",sessionID);

    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        long endTime = System.currentTimeMillis();
        long processingTime = endTime - startTime;

        HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();
        String sessionID=request.getSession().getId();
        String userAgent = request.getHeader("User-Agent");
        log.info("session id为: {}的请求已被销毁",sessionID);
        log.info("请求处理的时间为：{}ms",processingTime);
        log.info("User-Agent:{}",userAgent);
    }
}
