﻿
Процедура ПередЗаписью(Отказ)
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.УИН) Тогда
		ЭтотОбъект.УИН = Новый УникальныйИдентификатор();	
	КонецЕсли;
	
КонецПроцедуры