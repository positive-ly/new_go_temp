package controllers

import (
	"common/auth"
	"common/base"
	"common/validator"
	"{{.ProjectName}}/config"
	"{{.ProjectName}}/models"
)

type {{.TitleName}}Controller struct {
	base.BaseApiController
}

func (this *{{.TitleName}}Controller) Prepare() {
	this.SetAppInfo(config.DefaultConfig)
}

func (this *{{.TitleName}}Controller) Query() {
	err := this.ParseWithQueryOptions(config.DefaultConfig.Page)
	if err != nil {
		this.ResponseError("查询{{.Remark}}", err.Error())
		return
	}
	uis := auth.GetUserInfoSessFromContext(this.Ctx)
	if uis.Userid == "" || uis.Username == "" {
		this.ResponseError("权限验证", "用户信息异常")
		return
	}
	if !uis.IsAdmin {
		this.QueryOption.AddExtras("creator", uis.Username)
	}

	items := make([]*models.{{.TitleName}}, 0)
	total, err := this.OrmQuery(this.QueryOption, new(models.{{.TitleName}}), &items)
	if err != nil {
		this.ResponseError("查询{{.Remark}}", err.Error())
		return
	}
	this.AddResponseResultItems(items, total)
	this.ResponseSuccess()
}

func (this *{{.TitleName}}Controller) Add() {
	item := new(models.{{.TitleName}})
	err := this.ParseWithCreateOptions(item, validator.VALID_MODE_ADD)
	if err != nil {
		this.ResponseError("添加{{.Remark}}", err.Error())
		return
	}
	uis := auth.GetUserInfoSessFromContext(this.Ctx)
	if uis.Userid == "" || uis.Username == "" {
		this.ResponseError("权限验证", "用户信息异常")
		return
	}
	item.Creator = uis.Username
	err = this.OrmCreate(item)
	if err != nil {
		this.ResponseError("添加{{.Remark}}", err.Error())
		return
	}
	this.AddResponseResultItem(item)
	this.ResponseSuccess()
}

func (this *{{.TitleName}}Controller) Update() {
	item := new(models.{{.TitleName}})
	err := this.ParseWithUpdateOptions(item, validator.VALID_MODE_UPATE)
	if err != nil {
		this.ResponseError("修改{{.Remark}}", err.Error())
		return
	}
	uis := auth.GetUserInfoSessFromContext(this.Ctx)
	if uis.Userid == "" || uis.Username == "" {
		this.ResponseError("权限验证", "用户信息异常")
		return
	}
	q_data, err := item.QueryById()
	if err != nil {
		this.ResponseError("修改{{.Remark}}", err.Error())
		return
	}
	if !uis.IsAdmin && q_data.Creator != uis.Username {
		this.ResponseError("修改{{.Remark}}", "权限不足")
	}
	this.UpdateOption.AddExcludes("serviceid", "ctime", "creator")
	this.UpdateOption.AddCols("utime")
	item.Utime = base.GetCurrentData()
	err = this.OrmUpdate(item, this.UpdateOption)
	if err != nil {
		this.ResponseError("修改{{.Remark}}", err.Error())
		return
	}
	item.ServiceId = q_data.ServiceId
	item.Ctime = q_data.Ctime
	item.Creator = q_data.Creator
	this.AddResponseResultItem(item)
	this.ResponseSuccess()
}

func (this *{{.TitleName}}Controller) Delete() {
	item := new(models.{{.TitleName}})
	err := this.ParseWithDeleteOptions(item, validator.VALID_MODE_DELETE)
	if err != nil {
		this.ResponseError("删除{{.Remark}}", err.Error())
		return
	}
	uis := auth.GetUserInfoSessFromContext(this.Ctx)
	if uis.Userid == "" || uis.Username == "" {
		this.ResponseError("权限验证", "用户信息异常")
		return
	}
	q_data, err := item.QueryById()
	if err != nil {
		this.ResponseError("删除{{.Remark}}", err.Error())
		return
	}
	if !uis.IsAdmin && q_data.Creator != uis.Username {
		this.ResponseError("删除{{.Remark}}", "权限不足")
		return
	}
	err = this.OrmDelete(item)
	if err != nil {
		this.ResponseError("删除{{.Remark}}", err.Error())
		return
	}
	this.ResponseSuccess()
}
