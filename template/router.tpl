package routers

import (
	. "common/router"
	"{{.ProjectName}}/controllers"
)

//Routers = append(Routers, {{.AllLower}}Router...)
var {{.AllLower}}Router = []Router{
	{Group: "{{.Remark}}类", Name: "查询{{.Remark}}", Path: "/{{.AllLower}}s", Method: "get", Controller: &controllers.{{.TitleName}}Controller{},
		MappingMethod: "Query", Regexp: "", Desc: ""},
	{Group: "{{.Remark}}类", Name: "添加{{.Remark}}", Path: "/{{.AllLower}}s", Method: "post", Controller: &controllers.{{.TitleName}}Controller{},
		MappingMethod: "Add", Regexp: "", Desc: ""},
	{Group: "{{.Remark}}类", Name: "修改{{.Remark}}", Path: "/{{.AllLower}}s", Method: "put", Controller: &controllers.{{.TitleName}}Controller{},
		MappingMethod: "Update", Regexp: "", Desc: ""},
	{Group: "{{.Remark}}类", Name: "删除{{.Remark}}", Path: "/{{.AllLower}}s", Method: "delete", Controller: &controllers.{{.TitleName}}Controller{},
		MappingMethod: "Delete", Regexp: "", Desc: ""},
}
