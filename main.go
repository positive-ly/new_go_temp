package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"strings"
	"text/template"
)

var (
	separator                  = string(os.PathSeparator)
	controller_template_path   = []string{".", "template", "controller.tpl"}
	models_valid_template_path = []string{".", "template", "models_valid.tpl"}
	router_template_path       = []string{".", "template", "router.tpl"}

	out_controller_dir = []string{".", "tmp", "controllers"}
	out_model_dir      = []string{".", "tmp", "models"}
	out_router_dir     = []string{".", "tmp", "routers"}
)

type Generator struct {
	ProjectName string
	DefaultName string
	AllLower    string
	TitleName   string
	Remark      string
}

func main() {
	var project_name, file_name, remark string
	flag.StringVar(&project_name, "p", "", "项目名称")
	flag.StringVar(&file_name, "t", "", "数据库表名称")
	flag.StringVar(&remark, "r", "", "文件功能描述")
	flag.Parse()
	if project_name == "" || file_name == "" || remark == "" {
		fmt.Println("参数为空")
		os.Exit(2)
	}
	var all_lower_str, title_str []string
	for _, v := range strings.Split(strings.Replace(file_name, "-", "_", -1), "_") {
		all_lower_str = append(all_lower_str, strings.ToLower(v))
		title_str = append(title_str, strings.Title(v))
	}
	gert := &Generator{
		ProjectName: project_name,
		DefaultName: file_name,
		AllLower:    strings.Join(all_lower_str, "_"),
		TitleName:   strings.Join(title_str, ""),
		Remark:      remark,
	}
	//controller
	generator_file(gert, controller_template_path, out_controller_dir)
	//model
	generator_file(gert, models_valid_template_path, out_model_dir)
	//router
	generator_file(gert, router_template_path, out_router_dir)
}

func generator_file(gt *Generator, tempPath, outPath []string) {
	temp, err := template.ParseFiles(strings.Join(tempPath, separator))
	if err != nil {
		log.Fatal(err)
	}
	out_path := strings.Join(outPath, separator)
	os.MkdirAll(out_path, os.ModePerm)
	file, err := os.OpenFile(out_path+separator+gt.AllLower+".go", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()
	err = temp.Execute(file, gt)
	if err != nil {
		log.Fatal(err)
	}
}
