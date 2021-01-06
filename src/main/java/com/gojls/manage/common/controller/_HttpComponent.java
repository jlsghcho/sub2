package com.gojls.manage.common.controller;

import java.nio.charset.Charset;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

public class _HttpComponent {

	public static String[] sendGet(String url, String parameter, HttpHeaders headers) throws Exception{
		System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-sendGet(url, parameter, headers)");
		String[] return_msg = new String[2];
		return_msg[0] = "0";
		return_msg[1] = "";
		try{
			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	        factory.setReadTimeout(1000 * 30);  // 5분
	        factory.setConnectTimeout(5000);
	        
			HttpEntity<String> entity = new HttpEntity<String>("headers", headers);
			
			RestTemplate restTemplate = new RestTemplate(factory);
			if(parameter != "") { url = url +"?"+ parameter; }
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-url:"+ url);
			ResponseEntity<String> result = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
			
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result code:"+ result.getStatusCodeValue());
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result body:"+ result.getBody());
			
			return_msg[0] = result.getStatusCode().toString();
			return_msg[1] = result.getBody();
		}catch(Exception ex){
			ex.printStackTrace();
			
			return_msg[0] = "9999";
			return_msg[1] = ex.getMessage();
		}
		return return_msg;
	} 

	public static String[] sendPut(String url, String param, HttpHeaders headers) throws Exception{
		System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-sendPut(url, param, headers)");
		String[] return_msg = new String[2];
		return_msg[0] = "0";
		return_msg[1] = "";
		try{
			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	        factory.setReadTimeout(1000 * 30);  // 5분
	        factory.setConnectTimeout(5000);
	        
	        headers.setContentType(new MediaType("application", "json", Charset.forName("UTF-8")));
			HttpEntity<String> entity = new HttpEntity<String>(param, headers);
			RestTemplate restTemplate = new RestTemplate(factory);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-url:"+ url);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-param:"+ param);
			ResponseEntity<String> result = restTemplate.exchange(url, HttpMethod.PUT, entity, String.class);
			
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result code:"+ result.getStatusCodeValue());
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result body:"+ result.getBody());
			
			return_msg[0] = result.getStatusCode().toString();
			return_msg[1] = result.getBody();
		}catch(Exception ex){
			ex.printStackTrace();
			
			return_msg[0] = "9999";
			return_msg[1] = ex.getMessage();
		}
		return return_msg;
	}

	public static String[] sendPost(String url, String param, HttpHeaders headers) throws Exception{
		System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-sendPost(url, param, headers)");
		String[] return_msg = new String[2];
		return_msg[0] = "0";
		return_msg[1] = "";
		try{
			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	        factory.setReadTimeout(1000 * 30);  // 5분
	        factory.setConnectTimeout(5000);
	        
	        headers.setContentType(new MediaType("application", "x-www-form-urlencoded", Charset.forName("UTF-8")));
			HttpEntity<String> entity = new HttpEntity<String>(param, headers);
			RestTemplate restTemplate = new RestTemplate(factory);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-url:"+ url);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-param:"+ param);
			ResponseEntity<String> result = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
			
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result code:"+ result.getStatusCodeValue());
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result body:"+ result.getBody());
			
			return_msg[0] = result.getStatusCode().toString();
			return_msg[1] = result.getBody();
		}catch(Exception ex){
			ex.printStackTrace();
			
			return_msg[0] = "9999";
			return_msg[1] = ex.getMessage();
		}
		return return_msg;
	}
	
	public static String[] sendDelete(String url, String param, HttpHeaders headers) throws Exception{
		System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-sendDelete(url, param, headers)");
		String[] return_msg = new String[2];
		return_msg[0] = "0";
		return_msg[1] = "";
		try{
			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	        factory.setReadTimeout(1000 * 30);  // 5분
	        factory.setConnectTimeout(5000);
	        
	        headers.setContentType(new MediaType("application", "json", Charset.forName("UTF-8")));
			HttpEntity<String> entity = new HttpEntity<String>(param, headers);
			RestTemplate restTemplate = new RestTemplate(factory);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-url:"+ url);
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-param:"+ param);
			ResponseEntity<String> result = restTemplate.exchange(url, HttpMethod.DELETE, entity, String.class);
			
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result code:"+ result.getStatusCodeValue());
			System.out.println("## com.gojls.branch.common.controller.HttpComponent.class-result body:"+ result.getBody());
			
			return_msg[0] = result.getStatusCode().toString();
			return_msg[1] = result.getBody();
		}catch(Exception ex){
			ex.printStackTrace();
			
			return_msg[0] = "9999";
			return_msg[1] = ex.getMessage();
		}
		return return_msg;
	}
	
}
