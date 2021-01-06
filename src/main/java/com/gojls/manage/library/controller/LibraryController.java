package com.gojls.manage.library.controller;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
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

/* 내용 : 파일 업로드 다운로드 이미지업로드 및 썸네일 작업 까지 
 * 버젼/날짜 : 2017-08-29 (v 1.0)
 * */

@Controller
@RequestMapping("/lib")
public class LibraryController extends BaseController {
	
	@RequestMapping(value="/fileupload", method=RequestMethod.POST)
	public @ResponseBody void serviceFileUpload(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("files") MultipartFile files
			, @RequestParam("path") String path
			, @RequestParam("rootfl") Boolean rootfl
			, @RequestParam("datefl") Boolean datefl
			) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/LibraryController] serviceFileUpload");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String param_msg = "";
		try{
			if(files.isEmpty() || files == null) { param_msg = "파일이 없습니다."; throw new Exception(); }
			logger.info("file info ## name ="+ files.getOriginalFilename() +", size="+ files.getSize());
			
			// 파일경로 확정
			String allpath = "";
			String webpath = this.getClass().getResource("/").getPath();
			webpath = webpath.substring(0, webpath.lastIndexOf("WEB-INF")-1);
			String datepath = (datefl == true) ? "/"+ _Date.getNow("yyyyMMdd") : "";
			if(rootfl) {
				logger.info("only upload path use ## "+ path + datepath);
				allpath = path + datepath;
			}else {
				logger.info("server path use ## "+ webpath + path + datepath);
				allpath = webpath + path + datepath;
			}
			
			String ori_file_nm = files.getOriginalFilename().toString();
			String ori_ext_nm = ori_file_nm.substring(ori_file_nm.lastIndexOf(".")+1, ori_file_nm.length());
			String chg_file_nm = UUID.randomUUID().toString() +"."+ ori_ext_nm;
			
			if(files.getSize() > 0){
				File target_dir = new File(allpath);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				files.transferTo(new File(allpath +"/"+ chg_file_nm ));
				Map<String, Object> param_map = new HashMap<String, Object>();
				param_map.put("path", allpath);
				param_map.put("fullpath", allpath +"/"+ chg_file_nm);
				param_map.put("file_nm", chg_file_nm);
				param_map.put("file_ori_nm", ori_file_nm);
				param_map.put("file_size", files.getSize());
				param_map.put("file_ext", ori_ext_nm);
				
				resultMap = _Request.setResult("success", "" , JSONArray.fromObject(param_map).toString());
			}else {
				param_msg = "용량이 없는 파일입니다.";
				throw new Exception();
			}
			
		}catch(Exception ex){
			logger.error(ex.getMessage());
			if(param_msg.equals("")) { param_msg = ex.getMessage(); }
			resultMap = _Request.setResult("error", param_msg , null);
		}
		_Response.outJson(res, resultMap, false, "");
	}

	@RequestMapping(value="/fileupload/return", method=RequestMethod.POST)
	public String serviceFileUploadReturn(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("uploadfile") MultipartFile files
			, @RequestParam("path") String path
			, @RequestParam("rootfl") Boolean rootfl
			, @RequestParam("datefl") Boolean datefl
			, @RequestParam("param_rtn") String param_rtn
			, @RequestParam("upload_type") String upload_type
			) throws Exception {
		if (logger.isDebugEnabled()) {	logger.debug("[lib/LibraryController] serviceFileUploadReturn");	}

		String param_msg = "";
		try{
			if(files.isEmpty() || files == null) { param_msg = "파일이 없습니다."; throw new Exception(); }
			logger.info("file info ## name ="+ files.getOriginalFilename() +", size="+ files.getSize());
			
			// 파일경로 확정
			String allpath = "";
			String webpath = this.getClass().getResource("/").getPath();
			webpath = webpath.substring(0, webpath.lastIndexOf("WEB-INF")-1);
			String datepath = (datefl == true) ? "/"+ _Date.getNow("yyyyMMdd") : "";
			if(rootfl) {
				logger.info("only upload path use ## "+ path + datepath);
				allpath = path + datepath;
			}else {
				logger.info("server path use ## "+ webpath + path + datepath);
				allpath = webpath + path + datepath;
			}
			
			String ori_file_nm = files.getOriginalFilename().toString();
			String ori_ext_nm = ori_file_nm.substring(ori_file_nm.lastIndexOf(".")+1, ori_file_nm.length());
			String chg_file_nm = UUID.randomUUID().toString() +"."+ ori_ext_nm;
			
			if(files.getSize() > 0){
				File target_dir = new File(allpath);
				if(!target_dir.exists()) { target_dir.mkdirs(); }
				
				files.transferTo(new File(allpath +"/"+ chg_file_nm ));
				
				req.setAttribute("result", "success");
				req.setAttribute("path", allpath);
				req.setAttribute("fullpath", allpath +"/"+ chg_file_nm);
				req.setAttribute("file_nm", chg_file_nm);
				req.setAttribute("file_ori_nm", ori_file_nm);
				req.setAttribute("file_size", files.getSize());
				req.setAttribute("file_ext", ori_ext_nm);
				req.setAttribute("upload_type", upload_type);

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
		return param_rtn;
	}
	
	
	@RequestMapping(value="/filedownload", method=RequestMethod.GET)
	public @ResponseBody void serviceFileDownload(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("path") String path
			, @RequestParam("orifiles") String orifiles
			) throws Exception{
		if (logger.isDebugEnabled()) { logger.debug("[lib/LibraryController] serviceFileDownload"); }
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			String fileServerPath = "";
			File file = null;
			if(path.equals("")){
				resultMap = _Request.setResult("error", "다운로드할 파일경로가 없습니다.", null);
				throw new Exception();
			}else{
				file = new File(path);
				if(file.exists()){
					res.setHeader("Content-type", "application/unknown");
			        res.setHeader("Content-Disposition","attachment;filename=\""+ new String(orifiles.getBytes("euc-kr"),"8859_1") + "\";");
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
	
	@RequestMapping(value="/thumbnail", method=RequestMethod.POST)
	public @ResponseBody void serviceThumbImage(HttpServletRequest req, HttpServletResponse res
			, @RequestParam("thumbX") int thumbX
			, @RequestParam("thumbY") int thumbY
			, @RequestParam("thumbW") int thumbW
			, @RequestParam("thumbH") int thumbH
			, @RequestParam("oripath") String oripath
			, @RequestParam("orifile") String orifile
			, @RequestParam("path") String path 
			, @RequestParam("rootfl") Boolean rootfl
			, @RequestParam("datefl") Boolean datefl
			) throws Exception{
		if (logger.isDebugEnabled()) {	logger.debug("[lib/LibraryController] serviceThumbImage");	}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String param_msg = "";
		try{
			if(orifile.equals("") || orifile == null) { param_msg = "파일이 없습니다."; throw new Exception(); }

			// 파일경로 확정
			String allpath = "";
			String webpath = this.getClass().getResource("/").getPath();
			webpath = webpath.substring(0, webpath.lastIndexOf("WEB-INF")-1);
			String datepath = (datefl == true) ? "/"+ _Date.getNow("yyyyMMdd") : "";
			if(rootfl) {
				logger.info("only upload path use ## "+ path + datepath);
				allpath = path + datepath;
			}else {
				logger.info("server path use ## "+ webpath + path + datepath);
				allpath = webpath + path + datepath;
			}
			
			String ori_ext_nm = orifile.substring(orifile.lastIndexOf(".")+1, orifile.length());
			String chg_file_nm = orifile.substring(0, orifile.lastIndexOf(".")) +"_crop."+ ori_ext_nm;
			
			String ori_files = oripath +"/"+ orifile;
			String chg_files = allpath +"/"+ chg_file_nm;
			logger.info("change file ## "+ ori_files +" > "+ chg_files);
			
			Thumbnails.of(ori_files)
				.sourceRegion(thumbX, thumbY, thumbW-thumbX, thumbH-thumbY)
				.size(thumbW-thumbX, thumbH-thumbY)
				.toFile(chg_files);
			
			Map<String, Object> param_map = new HashMap<String, Object>();
			param_map.put("path", allpath);
			param_map.put("fullpath", chg_files);
			param_map.put("file_nm", chg_file_nm);
			resultMap = _Request.setResult("success", "" , JSONArray.fromObject(param_map).toString());
		}catch(Exception ex){
			logger.error(ex.getMessage());
			if(param_msg.equals("")) { param_msg = ex.getMessage(); }
			resultMap = _Request.setResult("error", param_msg , null);
		}
		_Response.outJson(res, resultMap, false, "");
	}
}
