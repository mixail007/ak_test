﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	//+++АК SHEP 2018.12.12 ИП-00018753.05: записываем поле "Производитель"
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда Возврат; КонецЕсли;
	
	Если ЭтотОбъект.Количество() > 0 Тогда
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			Если НЕ ЗначениеЗаполнено(Запись.Ссылка) Тогда Продолжить; КонецЕсли;
			
			Запись.Производитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Ссылка, "Производитель");
			
		КонецЦикла;
		
	КонецЕсли;
	//---АК SHEP 2018.12.12
	
КонецПроцедуры
