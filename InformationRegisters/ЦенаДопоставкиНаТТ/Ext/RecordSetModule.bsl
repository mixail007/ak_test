﻿Перем ЗаписыватьАвтораИзменений Экспорт;

//+++АК sole 2018.07.03 ИП-00018321.01
Процедура Конструктор()
	ЗаписыватьАвтораИзменений = Истина;
КонецПроцедуры

//+++АК sole 2018.06.28 ИП-00018321.01
Процедура ПередЗаписью(Отказ, Замещение)
	
	Перем мТекущийПользователь;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаписыватьАвтораИзменений Тогда
		
		ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
		Для Каждого Запись Из ЭтотОбъект Цикл
			Запись.АвторИзменений = мТекущийПользователь;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Конструктор();