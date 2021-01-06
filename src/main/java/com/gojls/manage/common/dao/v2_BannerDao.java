package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.v2_BannerModel;
import com.gojls.manage.common.model.v2_SearchModel;

public interface v2_BannerDao {
	public List<v2_BannerModel> select_banner_list(v2_SearchModel schVo);
	public int select_banner_overlap_check(v2_BannerModel bannerVo);
	public int insert_banner_save(v2_BannerModel bannerVo);
	public int update_banner_save(v2_BannerModel bannerVo);
	public int delete_banner_save(v2_BannerModel bannerVo);
}
