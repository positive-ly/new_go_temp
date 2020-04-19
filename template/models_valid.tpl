package models

import (
	"common/validator"

	"github.com/astaxie/beego/validation"
)

func (this *{{.TitleName}}) getBaseValidation() *validation.Validation {
	valid := new(validation.Validation)
	return valid
}
func (this *{{.TitleName}}) getAddValidation() *validation.Validation {
	valid := this.getBaseValidation()
	valid.Required(this.ServiceId, "serviceid").Message("服务标识为空")
	return valid
}
func (this *{{.TitleName}}) getUpdateValidation() *validation.Validation {
	valid := this.getBaseValidation()
	valid.Required(this.Id, "id").Message("标识为空")
	return valid
}
func (this *{{.TitleName}}) getDeleteValidation() *validation.Validation {
	valid := this.getBaseValidation()
	valid.Required(this.Id, "id").Message("标识为空")
	return valid
}

func (this *{{.TitleName}}) GetValidationByMode(mode int) *validation.Validation {
	switch mode {
	case validator.VALID_MODE_ADD:
		return this.getAddValidation()
	case validator.VALID_MODE_UPATE:
		return this.getUpdateValidation()
	case validator.VALID_MODE_DELETE:
		return this.getDeleteValidation()
	}
	return nil
}
func (m *{{.TitleName}}) GetName() string {
	return "{{.TitleName}}"
}
