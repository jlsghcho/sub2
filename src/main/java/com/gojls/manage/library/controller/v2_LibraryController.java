package com.gojls.manage.library.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64.Decoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.gojls.manage.common.controller.BaseController;
import com.gojls.util._Date;
import com.gojls.util._Request;
import com.gojls.util._Response;

import net.coobird.thumbnailator.Thumbnails;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/lib/v2")
public class v2_LibraryController extends BaseController{
	
	@Value("#{globalContext['UPLOAD_ROOTFL']?:''}") private String UPLOAD_ROOTFL;
	@Value("#{globalContext['UPLOAD_FILE_PATH']?:''}") private String UPLOAD_FILE_PATH;
	@Value("#{globalContext['UPLOAD_FILE_DOMAIN']?:''}") private String UPLOAD_FILE_DOMAIN;
	@Value("#{globalContext['UPLOAD_OPEN_ROOTFL']?:''}") private String UPLOAD_OPEN_ROOTFL;
	@Value("#{globalContext['UPLOAD_OPEN_FILE_PATH']?:''}") private String UPLOAD_OPEN_FILE_PATH;
	@Value("#{globalContext['UPLOAD_OPEN_FILE_DOMAIN']?:''}") private String UPLOAD_OPEN_FILE_DOMAIN;
	
	@RequestMapping(value="/upload/banner", method=RequestMethod.POST)
	@ResponseBody
	public void banner_image_upload(HttpServletRequest req, HttpServletResponse res, @RequestParam("files") MultipartFile files, @RequestParam("banner_location") String banner_location) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] banner_image_upload");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try{
			if(files.isEmpty() || files == null) { result_map = _Request.setResult("error", "파일이 없습니다.", null); throw new Exception(); }
			
			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			
			String path_final = (UPLOAD_ROOTFL.equals("Y")) ? UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);
			
			String file_origin_name = files.getOriginalFilename().toString();
			String file_origin_ext_name = file_origin_name.substring(file_origin_name.lastIndexOf(".")+1, file_origin_name.length());
			String file_change_name = UUID.randomUUID().toString() +"."+ file_origin_ext_name;
			
			if(files.getSize() > 0){
				File target_dir = new File(path_final);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				files.transferTo(new File(path_final +"/"+ file_change_name )); 
				
				if(UPLOAD_ROOTFL.equals("N")) { path_final = UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd"); } //로컬일때만 적용되게끔 
				
				JSONObject param_obj = new JSONObject();
				param_obj.put("file_url_domain", UPLOAD_FILE_DOMAIN);
				param_obj.put("file_path", path_final);
				param_obj.put("file_full_path", path_final +"/"+ file_change_name);
				param_obj.put("file_change_name", file_change_name);
				param_obj.put("file_origin_name", file_origin_name);
				param_obj.put("file_size", files.getSize());
				param_obj.put("file_origin_ext_name", file_origin_ext_name);
				param_obj.put("banner_position", banner_location);

				result_map = _Request.setResult("success", "", param_obj.toString());
			}else {
				result_map = _Request.setResult("error", "파일 용량이 없습니다.", null);
				throw new Exception();
			}
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", ex.getMessage(), null);
		}		
		_Response.outJson(res, result_map, false, "");
	}

	@RequestMapping(value="/make/thumbnail", method=RequestMethod.POST, headers = {"Accept=application/json"}, produces=MediaType.APPLICATION_JSON_VALUE, consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void thumb_image_upload(HttpServletRequest req, HttpServletResponse res) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] thumb_image_upload");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String param_msg = "";
		try{
			JSONObject obj_body = JSONObject.fromObject(_Request.getBody(req));
			int thumb_X = obj_body.getInt("thumb_X");
			int thumb_Y = obj_body.getInt("thumb_Y");
			int thumb_W = obj_body.getInt("thumb_W");
			int thumb_H = obj_body.getInt("thumb_H");
			int fixed_size_W = obj_body.getInt("fixed_size_W");
			int fixed_size_H = obj_body.getInt("fixed_size_H");
			String origin_image_path = obj_body.getString("origin_image_path").replace(UPLOAD_FILE_DOMAIN, "");
			if(origin_image_path.equals("") || origin_image_path == null) { param_msg = "파일이 없습니다."; throw new Exception(); }

			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			String path_final = (UPLOAD_ROOTFL.equals("Y")) ? UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);

			String origin_ext_name = origin_image_path.substring(origin_image_path.lastIndexOf(".")+1, origin_image_path.length());
			String change_file = origin_image_path.substring(0, origin_image_path.lastIndexOf(".")) +"_crop."+ origin_ext_name;
			logger.info("change file ## "+ origin_image_path +" > "+ change_file);
			
			/* 로컬에서 작업할경우 적절하게 변경 */
			if(UPLOAD_ROOTFL.equals("N")) { 
				origin_image_path = path_web + origin_image_path; change_file = path_web + change_file; 
			}
			
			if(fixed_size_W == 0) {
				fixed_size_W = thumb_W-thumb_X;
				fixed_size_H = thumb_H-thumb_Y;
			}
			
			Thumbnails.of(origin_image_path)
				.sourceRegion(thumb_X, thumb_Y, thumb_W-thumb_X, thumb_H-thumb_Y)
				.size(fixed_size_W, fixed_size_H)
				.toFile(change_file);
			
			/* 로컬에서 작업할경우 적절하게 변경 */
			if(UPLOAD_ROOTFL.equals("N")) { change_file = change_file.replace(path_web, ""); 
			}else { change_file = UPLOAD_FILE_DOMAIN + change_file; }

			Map<String, Object> param_map = new HashMap<String, Object>();
			param_map.put("change_file", change_file);
			resultMap = _Request.setResult("success", "" , JSONArray.fromObject(param_map).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			if(param_msg.equals("")) { param_msg = ex.getMessage(); }
			resultMap = _Request.setResult("error", param_msg , null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
	
	@RequestMapping(value="/upload/etc/{banner_position}", method=RequestMethod.POST)
	public String etc_image_upload(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("banner_file") MultipartFile files
			, @PathVariable("banner_position") String banner_position) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] banner_image_upload");	}
		String param_msg = "";
		try{
			if(files.isEmpty() || files == null) { param_msg = "파일이 없습니다."; throw new Exception(); }
			
			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			String path_final = (UPLOAD_ROOTFL.equals("Y")) ? UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);
			
			String file_origin_name = files.getOriginalFilename().toString();
			String file_origin_ext_name = file_origin_name.substring(file_origin_name.lastIndexOf(".")+1, file_origin_name.length());
			String file_change_name = UUID.randomUUID().toString() +"."+ file_origin_ext_name;
			
			if(files.getSize() > 0){
				File target_dir = new File(path_final);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				files.transferTo(new File(path_final +"/"+ file_change_name )); 
				
				if(UPLOAD_ROOTFL.equals("N")) { path_final = UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd"); } //로컬일때만 적용되게끔 
				
				req.setAttribute("result", "success");
				req.setAttribute("param_msg", param_msg);
				req.setAttribute("file_url_domain", UPLOAD_FILE_DOMAIN);
				req.setAttribute("file_path", path_final);
				req.setAttribute("file_full_path", path_final +"/"+ file_change_name);
				req.setAttribute("file_change_name", file_change_name);
				req.setAttribute("file_origin_name", file_origin_name);
				req.setAttribute("file_size", files.getSize());
				req.setAttribute("file_origin_ext_name", file_origin_ext_name);
				req.setAttribute("banner_position", banner_position);
			}else {
				param_msg = "용량이 없는 파일입니다.";
				throw new Exception();
			}
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			if(param_msg.equals("")) { param_msg = ex.getMessage(); }
			req.setAttribute("result", "fail");
			req.setAttribute("param_msg", param_msg);
		}		
		return "/v2/popup/upload_banner_rtn";
	}
	
	@RequestMapping(value="/dropzone/upload", method=RequestMethod.POST)
	@ResponseBody
	public void dropzone_image_upload(HttpServletRequest req, HttpServletResponse res, @RequestParam("file") MultipartFile files) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] dropzone_image_upload");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			if(files.isEmpty() || files == null) { result_map = _Request.setResult("error", "파일이 없습니다.", null); throw new Exception(); }
			
			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			String path_final = (UPLOAD_ROOTFL.equals("Y")) ? UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);
			
			String file_origin_name = files.getOriginalFilename().toString();
			String file_origin_ext_name = file_origin_name.substring(file_origin_name.lastIndexOf(".")+1, file_origin_name.length());
			String file_change_name = UUID.randomUUID().toString() +"."+ file_origin_ext_name;
			
			if(files.getSize() > 0){
				File target_dir = new File(path_final);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				files.transferTo(new File(path_final +"/"+ file_change_name )); 
				
				if(UPLOAD_ROOTFL.equals("N")) { path_final = UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd"); } //로컬일때만 적용되게끔 
				
				JSONObject param_obj = new JSONObject();
				param_obj.put("file_url_domain", UPLOAD_FILE_DOMAIN);
				param_obj.put("file_path", path_final);
				param_obj.put("file_full_path", path_final +"/"+ file_change_name);
				param_obj.put("file_change_name", file_change_name);
				param_obj.put("file_origin_name", file_origin_name);
				param_obj.put("file_size", files.getSize());
				param_obj.put("file_origin_ext_name", file_origin_ext_name);

				result_map = _Request.setResult("success", "", param_obj.toString());
			}else {
				result_map = _Request.setResult("error", "파일 용량이 없습니다.", null);
				throw new Exception();
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", ex.getMessage(), null);
		}		
		_Response.outJson(res, result_map, false, "");
	}

	@RequestMapping(value="/upload/files", method=RequestMethod.POST)
	@ResponseBody
	public void set_upload(HttpServletRequest req, HttpServletResponse res, @RequestParam("files") MultipartFile param_files) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] set_upload");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			if(param_files.isEmpty() || param_files == null) { result_map = _Request.setResult("error", "파일이 없습니다.", null); throw new Exception(); }
			
			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			String path_final = (UPLOAD_ROOTFL.equals("Y")) ? UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);
			
			String file_origin_name = param_files.getOriginalFilename().toString();
			String file_origin_ext_name = file_origin_name.substring(file_origin_name.lastIndexOf(".")+1, file_origin_name.length());
			String file_change_name = UUID.randomUUID().toString() +"."+ file_origin_ext_name;
			
			if(param_files.getSize() > 0){
				File target_dir = new File(path_final);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				param_files.transferTo(new File(path_final +"/"+ file_change_name )); 
				
				if(UPLOAD_ROOTFL.equals("N")) { path_final = UPLOAD_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd"); } //로컬일때만 적용되게끔 
				
				JSONObject param_obj = new JSONObject();
				param_obj.put("file_url_domain", UPLOAD_FILE_DOMAIN);
				param_obj.put("file_path", path_final);
				param_obj.put("file_full_path", path_final +"/"+ file_change_name);
				param_obj.put("file_change_name", file_change_name);
				param_obj.put("file_origin_name", file_origin_name);
				param_obj.put("file_size", param_files.getSize());
				param_obj.put("file_origin_ext_name", file_origin_ext_name);

				result_map = _Request.setResult("success", "", param_obj.toString());
			}else {
				result_map = _Request.setResult("error", "파일 용량이 없습니다.", null);
				throw new Exception();
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", ex.getMessage(), null);
		}		
		_Response.outJson(res, result_map, false, "");
	}

	@RequestMapping(value="/upload/open/files", method=RequestMethod.POST)
	@ResponseBody
	public void set_open_upload(HttpServletRequest req, HttpServletResponse res, @RequestParam("files") MultipartFile param_files) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/v2_LibraryController] set_open_upload");	}
		Map<String, Object> result_map = new HashMap<String, Object>();
		try {
			if(param_files.isEmpty() || param_files == null) { result_map = _Request.setResult("error", "파일이 없습니다.", null); throw new Exception(); }
			
			// 파일경로 확정
			String path_web = this.getClass().getResource("/").getPath();
			path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
			String path_final = (UPLOAD_OPEN_ROOTFL.equals("Y")) ? UPLOAD_OPEN_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd") : path_web + UPLOAD_OPEN_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd");
			logger.info("## path_final = "+ path_final);
			
			String file_origin_name = param_files.getOriginalFilename().toString();
			String file_origin_ext_name = file_origin_name.substring(file_origin_name.lastIndexOf(".")+1, file_origin_name.length());
			String file_change_name = UUID.randomUUID().toString() +"."+ file_origin_ext_name;
			
			if(param_files.getSize() > 0){
				File target_dir = new File(path_final);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				param_files.transferTo(new File(path_final +"/"+ file_change_name )); 
				
				if(UPLOAD_OPEN_ROOTFL.equals("N")) { path_final = UPLOAD_OPEN_FILE_PATH + "/"+ _Date.getNow("yyyyMMdd"); } //로컬일때만 적용되게끔 
				
				JSONObject param_obj = new JSONObject();
				param_obj.put("file_url_domain", UPLOAD_OPEN_FILE_DOMAIN);
				param_obj.put("file_path", path_final);
				param_obj.put("file_full_path", path_final +"/"+ file_change_name);
				param_obj.put("file_change_name", file_change_name);
				param_obj.put("file_origin_name", file_origin_name);
				param_obj.put("file_size", param_files.getSize());
				param_obj.put("file_origin_ext_name", file_origin_ext_name);

				result_map = _Request.setResult("success", "", param_obj.toString());
			}else {
				result_map = _Request.setResult("error", "파일 용량이 없습니다.", null);
				throw new Exception();
			}
		}catch(Exception ex){
			logger.error(ex.getMessage());
			result_map = _Request.setResult("error", ex.getMessage(), null);
		}		
		_Response.outJson(res, result_map, false, "");
	}
	
	@RequestMapping(value="/download", method=RequestMethod.GET)
	public @ResponseBody void serviceFileDownload(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("file_path") String file_path
			, @RequestParam("file_nm") String file_nm
			) throws Exception{
		if (logger.isDebugEnabled()) { logger.debug("[lib/LibraryController] serviceFileDownload"); }
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			File file = null;
			if(file_path.equals("")){
				resultMap = _Request.setResult("error", "다운로드할 파일경로가 없습니다.", null);
				throw new Exception();
			}else{
				if(file_path.indexOf("http") > -1) {
					try {
						URL url = new URL(file_path);
						BufferedInputStream bufferedInputStream = new  BufferedInputStream(url.openStream());
						String path_web = this.getClass().getResource("/").getPath();
						path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
						FileOutputStream stream = new FileOutputStream(path_web +"/temp_file");

						int count=0;
						byte[] b1 = new byte[100];
						while((count = bufferedInputStream.read(b1)) != -1) {
						     //System.out.println("b1:"+b1+">>"+count+ ">> KB downloaded:"+new File(path_web +"/temp_file").length()/1024);
						     stream.write(b1, 0, count);
						}
						file_path = path_web +"/temp_file";
					}catch(IOException eex) {
						eex.printStackTrace();
						resultMap = _Request.setResult("error", "다운로드할 파일URL이 없습니다.", null); throw new Exception();
					}
				}				
				
				file = new File(file_path);
				if(file.exists()){
					res.setHeader("Content-type", "application/unknown");
			        res.setHeader("Content-Disposition","attachment;filename=\""+ new String(file_nm.getBytes("euc-kr"),"8859_1") + "\";");
				    // 요청된 파일을 읽어서 클라이언트쪽으로 저장한다.
			        FileInputStream fileInputStream = new FileInputStream(file);
			        ServletOutputStream servletOutputStream = res.getOutputStream();
			         
			        byte b [] = new byte[1024];
			        int data = 0;
			         
			        while((data=(fileInputStream.read(b, 0, b.length))) != -1){ servletOutputStream.write(b, 0, data); }
			        servletOutputStream.flush();
			        servletOutputStream.close();
			        fileInputStream.close();
				}else{
					resultMap = _Request.setResult("error", "다운로드할 파일이 없습니다.", null); throw new Exception();
				}
			}
		}catch(Exception ex){
			logger.error("[lib/LibraryController] ERROR ##"+ resultMap.toString());
			ex.printStackTrace();
		}
	}	

	@RequestMapping(value="/downloads", method=RequestMethod.GET)
	public @ResponseBody void serviceFilesDownload(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("file_path") String file_path
			, @RequestParam("file_nm") String file_nm
			) throws Exception{
		if (logger.isDebugEnabled()) { logger.debug("[lib/LibraryController] serviceFileDownload"); }
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			String zip_file_nm = "attachments_"+_Date.getNow("yyyyMMddHHmmss")+".zip";
			String zip_file_path = "";
			String[] files = null;
			File file = null;
			File subfile = null;
			if(file_path.equals("")){
				resultMap = _Request.setResult("error", "다운로드할 파일경로가 없습니다.", null);
				throw new Exception();
			}else{ 
				file_path = file_path.replaceAll("/2/", "+");
				file_path = file_path.replaceAll("/3/", "%");
				file_path = file_path.replaceAll("/5/", "&");
				
				String[] file_path_list = file_path.split(",");
				String sel_file_path = "";
				String sel_file_nm = "";
				String sel_path = "";
				
				files = new String[file_path_list.length];
				
				if(file_path_list.length > 1){					
					file_nm = URLDecoder.decode(file_nm);
					//System.out.println("file_nm:"+file_nm);
										
					file_nm = file_nm.replaceAll("/4/", "#");
					file_nm = file_nm.replaceAll("/2/", "+");
					file_nm = file_nm.replaceAll("/5/", "&");

					//System.out.println("file_nm:"+file_nm);
					String[] file_nm_list = file_nm.split(","); 
					
					
					
					for (int i = 0; i < file_path_list.length; i++) {
						//System.out.println(i+" path:"+file_path_list[i]);
						//System.out.println(i+" name:"+file_nm_list[i]);
						sel_file_path = file_path_list[i];
						sel_file_nm = file_nm_list[i];
						
						/* 파일별 이동 */
						if(sel_file_path.indexOf("http") > -1) {
							try {
								URL url = new URL(sel_file_path);
								BufferedInputStream bufferedInputStream = new  BufferedInputStream(url.openStream());
								String path_web = this.getClass().getResource("/").getPath();
								path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1)+"/resources";
								//path_web = "E:/";
								//FileOutputStream stream = new FileOutputStream(path_web +"/temp_file");
								FileOutputStream stream = new FileOutputStream(path_web +"/"+sel_file_nm);
								
								int count=0;
								byte[] b1 = new byte[100];
								while((count = bufferedInputStream.read(b1)) != -1) {
								     //System.out.println("b1:"+b1+">>"+count+ ">> KB downloaded:"+new File(path_web +"/temp_file").length()/1024);
								     stream.write(b1, 0, count);
								}
								sel_file_path = path_web +"/"+sel_file_nm;
								files[i] = path_web+"/"+sel_file_nm;					            
					            zip_file_path = path_web;
					            //System.out.println("zip_file_path:"+zip_file_path);
								
							}catch(IOException eex) {
								eex.printStackTrace();
								resultMap = _Request.setResult("error", "다운로드할 파일URL이 없습니다.", null); throw new Exception();
							}
						}
					}		
					/* 개별파일 zip으로 묶기 */
					byte[] buf = new byte[4096];
					 
					try {
					    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zip_file_path+"/"+zip_file_nm));
					 
					    for (int i=0; i<files.length; i++) {
					        FileInputStream in = new FileInputStream(files[i]);
					        Path p = Paths.get(files[i]);
					        String fileName = p.getFileName().toString();
					                
					        ZipEntry ze = new ZipEntry(fileName);
					        out.putNextEntry(ze);
					          
					        int len;
					        while ((len = in.read(buf)) > 0) {
					            out.write(buf, 0, len);
					        }
					          
					        out.closeEntry();
					        in.close();
					    }
					          
					    out.close();
					} catch (IOException e) {
					    e.printStackTrace();
					}				
					/* 개별파일 zip으로 묶기   */
					

				    for (int i=0; i<files.length; i++) {
			            //System.out.println("files:"+files[i]);
						subfile = new File(files[i]);
						if(subfile.exists()){
				            //System.out.println("subfile check:"+subfile.exists());
							subfile.delete();
						}				    	
				    }

					file = new File(zip_file_path+"/"+zip_file_nm);
				}else if(file_path_list.length == 1){		
					//System.out.println("file_nm:"+file_nm);	
					if(file_path.indexOf("http") > -1) {
						try {
							URL url = new URL(file_path);
							BufferedInputStream bufferedInputStream = new  BufferedInputStream(url.openStream());
							String path_web = this.getClass().getResource("/").getPath();
							path_web = path_web.substring(0, path_web.lastIndexOf("WEB-INF")-1);
							FileOutputStream stream = new FileOutputStream(path_web +"/temp_file");

							int count=0;
							byte[] b1 = new byte[100];
							while((count = bufferedInputStream.read(b1)) != -1) {
							     //System.out.println("b1:"+b1+">>"+count+ ">> KB downloaded:"+new File(path_web +"/temp_file").length()/1024);
							     stream.write(b1, 0, count);
							}
							file_path = path_web +"/temp_file";
						}catch(IOException eex) {
							eex.printStackTrace();
							resultMap = _Request.setResult("error", "다운로드할 파일URL이 없습니다.", null); throw new Exception();
						}
						zip_file_nm = file_nm; 
					}
					file = new File(file_path);				
				}

				/* 최종 파일 다운로드 */
				if(file.exists()){
					res.setHeader("Content-type", "application/unknown");
			        res.setHeader("Content-Disposition","attachment;filename=\""+ new String(zip_file_nm.getBytes("euc-kr"),"8859_1") + "\";");
				    // 요청된 파일을 읽어서 클라이언트쪽으로 저장한다.
			        FileInputStream fileInputStream = new FileInputStream(file);
			        ServletOutputStream servletOutputStream = res.getOutputStream();
			         
			        byte b [] = new byte[1024];
			        int data = 0;
			         
			        while((data=(fileInputStream.read(b, 0, b.length))) != -1){ servletOutputStream.write(b, 0, data); }
			        servletOutputStream.flush();
			        servletOutputStream.close();
			        fileInputStream.close();
			        
			        file.delete();
				}else{
					resultMap = _Request.setResult("error", "다운로드할 파일이 없습니다.", null); throw new Exception();
				}
				/* 최종 파일 다운로드 */
			}
		}catch(Exception ex){
			logger.error("[lib/LibraryController] ERROR ##"+ resultMap.toString());
			ex.printStackTrace();
		}
	}	
	
	
}
