#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.МакетШаблона.ОтображатьЗаголовки = Истина;
	Элементы.МакетШаблона.Редактирование      = Истина;
	
	СформироватьСписокВыбораТипов();
	
	УстановитьУсловноеОформление();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ХранилищеДанных = ЕАС_ОбщегоНазначенияКопируемый.ПолучитьПрисоединенныеДанные(ТекущийОбъект.Ссылка, Перечисления.ЕАС_ВидыПрисоединенныхДанных.ТабличныйДокумент);
	
	Если ЗначениеЗаполнено(ХранилищеДанных) Тогда 
		МакетШаблона = ХранилищеДанных.Получить();
	КонецЕсли;
	
	УдалениеНеПривязанныхПолей(ТекущийОбъект.Ссылка, МакетШаблона);
	
	СформироватьДополнительныеПоляТаблиц();
	
КонецПроцедуры                  

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЕАС_ОбщегоНазначенияКопируемый.ЗаписатьПрисоединенныеДанные(ТекущийОбъект.Ссылка, Перечисления.ЕАС_ВидыПрисоединенныхДанных.ТабличныйДокумент, МакетШаблона);
	
	УдалениеНеПривязанныхПолей(ТекущийОбъект.Ссылка, МакетШаблона);
	
	СформироватьДополнительныеПоляТаблиц();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнениеПараметра(Команда)
	ТекущиеДанные = Элементы.ПараметрыЗаполнения.ТекущиеДанные;   
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаголовокФормы = СтрШаблон(НСтр("ru = 'Алгоритм заполнения параметра ""%1"", Шаблон - %2'"), ТекущиеДанные.Имя, Объект.Наименование);
	РедактированиеАлгоритма(ЗаголовокФормы, "Алгоритм", "ПараметрыЗаполнения");
КонецПроцедуры

&НаКлиенте
Процедура НачальноеЗаполнениеШаблона(Команда)
	ЗаголовокФормы = СтрШаблон(НСтр("ru = 'Алгоритм начального заполнения %1'"), Объект.Наименование);
	РедактированиеАлгоритма(ЗаголовокФормы, "АлгоритмНачальногоЗаполненияШаблона");
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗаполненияШаблона(Команда)
	ЗаголовокФормы = СтрШаблон(НСтр("ru = 'Алгоритм завершения заполнения %1'"), Объект.Наименование);
	РедактированиеАлгоритма(ЗаголовокФормы, "АлгоритмЗавершенияЗаполненияШаблона");
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеАлгоритма(ЗаголовокФормы, ИмяРеквизита, ИмяТЧ = Неопределено)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	Если ИмяТЧ = Неопределено Тогда
		ПараметрыФормы.Вставить("Текст", Объект[ИмяРеквизита]);
	Иначе	
		ТекущиеДанные = Элементы[ИмяТЧ].ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПараметрыФормы.Вставить("Текст", ТекущиеДанные[ИмяРеквизита]);
	КонецЕсли;	
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Реквизит", ИмяРеквизита);
	ДопПараметры.Вставить("ИмяТЧ",    ИмяТЧ);
	
	ОповещениеЗакрытия = Новый ОписаниеОповещения("ОкончаниеРедактированияАлгоритма", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("ОбщаяФорма.ЕАС_ФормаРедактированияТекста", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор,,,ОповещениеЗакрытия, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеРедактированияАлгоритма(Результат, ДопПараметры) Экспорт
	Перем ИмяРеквизита, ИмяТЧ;
	Если Результат <> Неопределено 
			И ДопПараметры.Свойство("Реквизит", ИмяРеквизита)
			И ИмяРеквизита <> Неопределено Тогда
		Если ДопПараметры.Свойство("ИмяТЧ", ИмяТЧ) И ИмяТЧ <> Неопределено Тогда	
			ТекущиеДанные = Элементы[ИмяТЧ].ТекущиеДанные;
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные[ИмяРеквизита] = Результат;
			КонецЕсли;
		Иначе		
			Объект[ИмяРеквизита] = Результат;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура НастроитьЗаполнениеПоля(Команда)
	
	Если Не ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСуществует(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для начала настройки требуется записать шаблон'"));
		Возврат;                                     
	КонецЕсли;	
	
	ВыделенныеОбласти = МакетШаблона.ВыделенныеОбласти;
	Если ВыделенныеОбласти.Количество() = 1 Тогда
		ВыделеннаяОбласть = ВыделенныеОбласти[0];
		Ячейка = МакетШаблона.Область(ВыделеннаяОбласть.Верх, ВыделеннаяОбласть.Лево);
		
		ПараметрыОткрытияФормы = Новый Структура;                        
		ЗначенияЗаполнения = Новый Структура;
		Если ЗначениеЗаполнено(ПоследнийВыбор) Тогда
			ЗначенияЗаполнения.Вставить("ЗначениеКопирования", ПоследнийВыбор);      
		Иначе
			ЗначенияЗаполнения.Вставить("Владелец", Объект.Ссылка);      
		КонецЕсли;	
		
		ПараметрыОткрытияФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ПараметрыОткрытияФормы.Вставить("ДопПараметрыПолей",  ДопПараметрыПолей);
		ПараметрыОткрытияФормы.Вставить("Верх", Ячейка.Верх);
		ПараметрыОткрытияФормы.Вставить("Лево", Ячейка.Лево);
		
		ПолеСсылка = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.СсылкаЯчейкиШаблона(Ячейка.Имя);
		Если ЗначениеЗаполнено(ПолеСсылка) Тогда
			Если ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСуществует(ПолеСсылка) Тогда 
				Если ЕАС_ОбщегоНазначенияВызовСервераКопируемый.ЗначениеРеквизитаОбъекта(ПолеСсылка, "ОбластьДанных") = Объект.ОбластьДанных Тогда
					ПараметрыОткрытияФормы.Вставить("Ключ", ПолеСсылка);       
				КонецЕсли; 	
			Иначе
				ТекстСообщения = НСтр("ru = 'Редактирование ячейки не рекомендуется. Возможно не завершен обмен.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат;
			КонецЕсли;	
		КонецЕсли;         
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Ячейка", Ячейка);
		ОповещениеПриЗакрытии = Новый ОписаниеОповещения("ЗавершениеРедактированияЯчейки", ЭтаФорма, ДопПараметры);
		ОткрытьФорму("Справочник.ЕАС_ПоляФормШаблонов.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтаФорма, , , , ОповещениеПриЗакрытии);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаполнение(Команда)
	Если Не ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСуществует(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для начала настройки требуется записать шаблон'"));
		Возврат;                                     
	КонецЕсли;	
	ВыделенныеОбласти = МакетШаблона.ВыделенныеОбласти;
	Если ВыделенныеОбласти.Количество() = 1 Тогда
		ВыделеннаяОбласть = ВыделенныеОбласти[0];
		Для Лево = ВыделеннаяОбласть.Лево По ВыделеннаяОбласть.Право Цикл
			Для Верх = ВыделеннаяОбласть.Верх По ВыделеннаяОбласть.Низ Цикл
				Ячейка = МакетШаблона.Область(Верх, Лево);
				ИмяЯчейки = Ячейка.Имя;
				
				ТекстСообщения = Неопределено;
				Если СтрРазделить(ИмяЯчейки, "_").Количество() = 5 Тогда
					// похоже на уид
					УИДСтрока_ = СтрЗаменить(ИмяЯчейки, "_","-");   
					СтатусУдаления = УдалитьПолеФормы(УИДСтрока_);
					Если СтатусУдаления = "Успешно" Тогда
						ТекстСообщения = НСтр("ru='Заполнение очищено'");
					Иначе	
						ТекстСообщения = НСтр("ru='Заполнение не было установлено'");
					КонецЕсли;	
					Если СтатусУдаления <> "НеверныйУИД" Тогда            
						Ячейка.Имя = Неопределено;
					КонецЕсли;	
				Иначе	
					ТекстСообщения = НСтр("ru='Заполнение не было установлено'");
					Ячейка.Имя = Неопределено;
				КонецЕсли;
				ТекстСообщения = СтрШаблон(Нстр("ru = 'Ячейка %1:%2 - %3'"),
											Формат(Верх, "ЧГ=0"),
											Формат(Лево, "ЧГ=0"),
											ТекстСообщения);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
				
			КонецЦикла;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьЗаполнение(Команда)
	МассивКопирования = Новый Массив;
	ЭтоПреваяОбласть = Истина;
	Для Каждого ВыделеннаяОбласть Из МакетШаблона.ВыделенныеОбласти Цикл
		Если ТипЗнч(ВыделеннаяОбласть) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			
			ПерваяЛево = ВыделеннаяОбласть.Лево;
			ПерваяВерх = ВыделеннаяОбласть.Верх;
			
			Для Лево = ВыделеннаяОбласть.Лево По ВыделеннаяОбласть.Право Цикл
				Для Верх = ВыделеннаяОбласть.Верх По ВыделеннаяОбласть.Низ Цикл
					Ячейка = МакетШаблона.Область(Верх, Лево);
					ПолеСсылка = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.СсылкаЯчейкиШаблона(Ячейка.Имя);
					Если ЗначениеЗаполнено(ПолеСсылка) Тогда
						Если ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСуществует(ПолеСсылка) Тогда
							ДанныеЯчейки = Новый Структура;
							ДанныеЯчейки.Вставить("ПерваяВерх",   ПерваяВерх);
							ДанныеЯчейки.Вставить("ПерваяЛево",   ПерваяЛево);
							ДанныеЯчейки.Вставить("Верх",   	  Верх);
							ДанныеЯчейки.Вставить("Лево",         Лево);
							ДанныеЯчейки.Вставить("Ссылка", 	  ПолеСсылка); 
							МассивКопирования.Добавить(ДанныеЯчейки);
						КонецЕсли;	
					КонецЕсли;	
				КонецЦикла;	
			КонецЦикла;	
			ЭтоПреваяОбласть = Ложь;
		КонецЕсли;	
	КонецЦикла;	                  
	Если МассивКопирования.Количество() = 0 Тогда
		Если ЭтоАдресВременногоХранилища(АдресКопирования) Тогда
			УдалитьИзВременногоХранилища(АдресКопирования);
			АдресКопирования = Неопределено;
		КонецЕсли;	
	Иначе	
		АдресКопирования = ПоместитьВоВременноеХранилище(МассивКопирования, УникальныйИдентификатор);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ВставитьЗаполнениеНаСервере(ПараметрыКопирования)
	Перем МассивКопирования, СтруктураКопирования;
	Перем Лево, Верх, ПолеСсылка;
	
	ПараметрыКопирования.Свойство("МассивКопирования",    МассивКопирования);
	ПараметрыКопирования.Свойство("СтруктураКопирования", СтруктураКопирования);
	
	НоваяЯчейка = МакетШаблона.ВыделенныеОбласти[0];
	
	НоваяВерх = Элементы.МакетШаблона.ТекущаяОбласть.Верх;
	НоваяЛево = Элементы.МакетШаблона.ТекущаяОбласть.Лево;
	
	Для Каждого ДанныеЯчейкиОткуда Из МассивКопирования Цикл
		Если ДанныеЯчейкиОткуда.ПерваяЛево <> НоваяЛево 
				Или ДанныеЯчейкиОткуда.ПерваяВерх <> НоваяВерх Тогда
			ДанныеЯчейкиОткуда.Свойство("Верх",   Верх);
			ДанныеЯчейкиОткуда.Свойство("Лево",   Лево);
			ДанныеЯчейкиОткуда.Свойство("Ссылка", ПолеСсылка); 
			
			Лево = Лево + НоваяЛево - ДанныеЯчейкиОткуда.ПерваяЛево;
			Верх = Верх + НоваяВерх - ДанныеЯчейкиОткуда.ПерваяВерх;
			
			НоваяЯчейка = МакетШаблона.Область(Верх, Лево);
			НоваяСсылка = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.СсылкаЯчейкиШаблона(НоваяЯчейка.Имя);
			
			Если ЗначениеЗаполнено(НоваяСсылка) Тогда
				ТекстСообщения = СтрШаблон(Нстр("ru = 'Ячейка %1:%2 - уже содержит настройки %3'"),
											Формат(Верх, "ЧГ=0"),
											Формат(Лево, "ЧГ=0"),
											НоваяСсылка);
											
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Иначе
				НачатьТранзакцию();
				Попытка
					НовоеПолеШаблона = Справочники.ЕАС_ПоляФормШаблонов.СоздатьЭлемент();
					ДанныеЗаполнения = Новый Структура("ЗначениеКопирования", ПолеСсылка);
					НовоеПолеШаблона.Заполнить(ДанныеЗаполнения);
					ЗаполнитьЗначенияСвойств(НовоеПолеШаблона, СтруктураКопирования);
					
					НовоеПолеШаблона.Наименование = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.НаименованиеПоляШаблона(Верх, Лево, НовоеПолеШаблона); 
					НовоеПолеШаблона.Записать();
					ИмяЯчейки = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.ИмяЯчейкиПоСсылке(НовоеПолеШаблона.Ссылка);
					Если ИмяЯчейки <> Неопределено Тогда
						УстановитьСвойстваЯчейки(НоваяЯчейка, НовоеПолеШаблона, ИмяЯчейки);
					Иначе	
						ВызватьИсключение "Не установлено имя ячейки";
					КонецЕсли;	
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					ТекстСообщения = СтрШаблон(Нстр("ru = 'Ячейка %1:%2 - ошибка %3'"),
											Формат(Верх, "ЧГ=0"),
											Формат(Лево, "ЧГ=0"),
											ОписаниеОшибки());
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				КонецПопытки;	
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;						
		
КонецПроцедуры

&НаКлиенте
Процедура ВставитьЗаполнение(Команда)
	Если ЭтоАдресВременногоХранилища(АдресКопирования) 
			И МакетШаблона.ВыделенныеОбласти.Количество() > 0 Тогда
			
		МассивКопирования = ПолучитьИзВременногоХранилища(АдресКопирования);
			
		ДопПараметры = Новый Структура("МассивКопирования", МассивКопирования); 
		ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаКопированияПолейЗавершение", ЭтотОбъект, ДопПараметры);
		ПараметрыОткрытияФормы = Новый Структура;
		ОткрытьФорму("ОбщаяФорма.ЕАС_НастройкаКопированияПолей", ПараметрыОткрытияФормы, ЭтаФорма, УникальныйИдентификатор, , , ОписаниеОповещения); 
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаКопированияПолейЗавершение(Результат, ДопПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Количество() > 0 Тогда
		ДопПараметры.Вставить("СтруктураКопирования", Результат);
		ВставитьЗаполнениеНаСервере(ДопПараметры);
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыЗаполнения

&НаКлиенте
Процедура ПараметрыЗаполненияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекущиеДанные = Элементы.ПараметрыЗаполнения.ТекущиеДанные;    
	
	Если ТекущиеДанные <> Неопределено Тогда          
		ТекущиеДанные.ТипУточнениеВФорме = Строка(ТекущиеДанные.ТипУточнениеВФорме);
		ОписаниеТипаСтруктура = ОписаниеТипаСтруктура(ТекущиеДанные.ТипВФорме);
		Если ОписаниеТипаСтруктура <> Неопределено Тогда
			СписокВыбора = ОписаниеТипаСтруктура.СписокВыбора;
		Иначе
			СписокВыбора = Новый СписокЗначений;
		КонецЕсли;	
		СписокВыбораТип = Элементы.ПараметрыЗаполненияТипУточнение.СписокВыбора;
		СписокВыбораТип.Очистить();
		Для Каждого ЭлементВыбора Из СписокВыбора Цикл
			СписокВыбораТип.Добавить(ЭлементВыбора.Представление, ЭлементВыбора.Представление);
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаполненияТипУточнениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПараметрыЗаполнения.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОписаниеТипаСтруктура = ОписаниеТипаСтруктура(ТекущиеДанные.ТипВФорме);
		Если ОписаниеТипаСтруктура <> Неопределено Тогда
			СписокВыбора = ОписаниеТипаСтруктура.СписокВыбора;
			Для Каждого ЭлементСписка Из СписокВыбора Цикл
				Если ЭлементСписка.Представление = ВыбранноеЗначение Тогда
					ТекущиеДанные.Тип = ЕАС_ОбщегоНазначенияВызовСервераКопируемый.ИмяТипаXML(ЭлементСписка.Значение);     
					Прервать;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
	КонецЕсли;
	                                                                 
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаполненияТипПриИзменении(Элемент)    
	
	ТекущиеДанные = Элементы.ПараметрыЗаполнения.ТекущиеДанные;   
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеТипаСтруктура = ОписаниеТипаСтруктура(ТекущиеДанные.ТипВФорме, ТекущиеДанные.Тип);
		
		Если ОписаниеТипаСтруктура = Неопределено Тогда
			ТекущиеДанные.ТипУточнениеВФорме = Неопределено;
			ТекущиеДанные.Тип                = Неопределено;
		Иначе	
			СписокВыбора = ОписаниеТипаСтруктура.СписокВыбора;
			//
			СписокВыбораТип = Элементы.ПараметрыЗаполненияТипУточнение.СписокВыбора;
			СписокВыбораТип.Очистить();
			Для Каждого ЭлементВыбора Из ОписаниеТипаСтруктура.СписокВыбора Цикл
				СписокВыбораТип.Добавить(ЭлементВыбора.Представление, ЭлементВыбора.Представление);
			КонецЦикла;	
		
			Если СписокВыбора.Количество() = 0 Тогда
				ТекущиеДанные.ТипУточнениеВФорме = Неопределено;
				Если ОписаниеТипаСтруктура.Примитивный Тогда
					ТекущиеДанные.Тип = ОписаниеТипаСтруктура.ПолноеИмяТипа;
				Иначе
					ТекущиеДанные.Тип = Неопределено;
				КонецЕсли;	
				
			ИначеЕсли СписокВыбора.Количество() = 1 Тогда
				ТекущиеДанные.ТипУточнениеВФорме = СписокВыбора[0].Представление;
				ТекущиеДанные.Тип = ОписаниеТипаСтруктура.ПолноеИмяТипа;     
				
			ИначеЕсли ТекущиеДанные.Тип <> ОписаниеТипаСтруктура.ПолноеИмяТипа Тогда
				ТекущиеДанные.ТипУточнениеВФорме = Неопределено;
				ТекущиеДанные.Тип                = Неопределено;       
				
			КонецЕсли;	
		 КонецЕсли;
	КонецЕсли;	         
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОписаниеТипаСтруктура(ПредставлениеТипа, ПолноеИмяТипа = Неопределено)
	Возврат ЕАС_ОбщегоНазначенияСерверПовтИсп.ОписаниеТипаСтруктура(ПредставлениеТипа, ПолноеИмяТипа);
КонецФункции                                       

&НаСервере
Процедура СформироватьСписокВыбораТипов()
	
	СписокВыбораТипов = Элементы.ПараметрыЗаполненияТипВФорме.СписокВыбора;   
	СписокВыбораТипов.Очистить();
	
	Для Каждого СтрокаТипов Из ЕАС_ОбщегоНазначенияСерверПовтИсп.ТаблицаТиповПараметров() Цикл
		Если СписокВыбораТипов.НайтиПоЗначению(СтрокаТипов.ПредставлениеТипа) = Неопределено Тогда
			СписокВыбораТипов.Добавить(СтрокаТипов.ПредставлениеТипа);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаполненияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда 
		
		Отказ = Истина;
		
		ЭлементПараметр = Объект.ПараметрыЗаполнения.Добавить();
		ЭлементПараметр.Имя = ПолучитьИмяПараметра();
		
	КонецЕсли;	
	
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяПараметра()
	ПараметрыВФорме = Объект.ПараметрыЗаполнения;
	Флаг = Истина;
	Индекс = 0;
	                                                  
	Пока Флаг Цикл
		Имя = "Параметр" + Строка(Формат(Индекс, "ЧН=-"));
		Имя = СтрЗаменить(Имя, "-", "");
		Фильтр = Новый Структура("Имя", Имя);
		
		ОтфильтрованныеСтроки = ПараметрыВФорме.НайтиСтроки(Фильтр);
		Если ОтфильтрованныеСтроки.Количество() = 0 Тогда
			Результат = Имя;
			Флаг = Ложь;
		КонецЕсли;
		Индекс = Индекс+1;
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьДополнительныеПоляТаблиц()
	ТаблицаТипов = ЕАС_ОбщегоНазначенияСерверПовтИсп.ТаблицаТиповПараметров();
	Для Каждого СтрокаПараметров Из Объект.ПараметрыЗаполнения Цикл
		СтрокиТипов = ТаблицаТипов.НайтиСтроки(Новый Структура("ПолноеИмяТипа", СтрокаПараметров.Тип));
		Если СтрокиТипов.Количество() = 1 Тогда
			СтрокаТипов = СтрокиТипов[0];
			СтрокаПараметров.ТипУточнениеВФорме = СтрокаТипов.Тип;
			СтрокаПараметров.ТипВФорме          = СтрокаТипов.ПредставлениеТипа;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьПолеФормы(УИДСтрока)
	Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(УИДСтрока) Тогда
		УИД = Новый УникальныйИдентификатор(УИДСтрока);
	Иначе	
		Возврат "НеверныйУИД";
	КонецЕсли;	
	ПолеСсылка = ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСправочникаПоУИД("ЕАС_ПоляФормШаблонов", УИД);
	Если ЕАС_ОбщегоНазначенияВызовСервераКопируемый.СсылкаСуществуетИНеУдалена("Справочник.ЕАС_ПоляФормШаблонов", ПолеСсылка) Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ЕАС_ПоляФормШаблонов");
		ЭлементБлокировки.Режим=РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ПолеСсылка);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			ОбъектПолеФормы = ПолеСсылка.ПолучитьОбъект();
			ОбъектПолеФормы.Удалить();
			ЗафиксироватьТранзакцию();
			Возврат "Успешно";
		Исключение
			ОтменитьТранзакцию();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			Возврат "ОшибкаБлокировки";
		КонецПопытки;	
	Иначе
		Возврат "НетЭлемента";
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЗавершениеРедактированияЯчейки(РезультатЗакрытия, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Ячейка = ДопПараметры.Ячейка;          
		
		ИмяЯчейки = ЕАС_ОбработкаШаблоновКлиентСерверКопируемый.ИмяЯчейкиПоСсылке(РезультатЗакрытия);
		Если ИмяЯчейки <> Неопределено Тогда
			ПолеШаблонаСтруктура = ЕАС_ОбщегоНазначенияВызовСервераКопируемый.ЗначенияРеквизитовОбъекта(РезультатЗакрытия, "РучнаяКорректировка,ДопПараметр,ТочностьЧисла");
			УстановитьСвойстваЯчейки(Ячейка, ПолеШаблонаСтруктура, ИмяЯчейки);
			
			ПоследнийВыбор = РезультатЗакрытия;
			Если ЗначениеЗаполнено(ПолеШаблонаСтруктура.ДопПараметр) Тогда
				НайденноеЗначение = ДопПараметрыПолей.НайтиПоЗначению(ПолеШаблонаСтруктура.ДопПараметр);
				Если НайденноеЗначение = Неопределено Тогда
					ДопПараметрыПолей.Вставить(0, ПолеШаблонаСтруктура.ДопПараметр);
				Иначе	
					ДопПараметрыПолей.Сдвинуть(НайденноеЗначение, - ДопПараметрыПолей.Индекс(НайденноеЗначение)); 
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;	
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЯчейки(Ячейка, ПолеШаблона, ИмяЯчейки)
	Ячейка.Имя        = ИмяЯчейки;
	Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Текст;
	Ячейка.Параметр   = "";     
	Ячейка.Текст      = "<>";
	
	Если ПолеШаблона.РучнаяКорректировка  Тогда
		Ячейка.ЦветФона = WebЦвета.СветлоНебесноГолубой;
	Иначе
		Ячейка.ЦветФона = WebЦвета.Циан;    
	КонецЕсли;	                                        
	Ячейка.Формат = "ЧДЦ=" + ПолеШаблона.ТочностьЧисла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалениеНеПривязанныхПолей(Ссылка, ТабличныйДокумент)
	
	ВыборкаПолейШаблона = ЕАС_ОбработкаШаблоновКопируемый.ВыборкаПолейШаблона(ТабличныйДокумент, Ссылка);
	
	МассивСсылок = Новый Массив;
	Пока ВыборкаПолейШаблона.Следующий() Цикл
		МассивСсылок.Добавить(ВыборкаПолейШаблона.Ссылка);
	КонецЦикла;	
	
	Запрос = Новый Запрос;        
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВсеПоляШаблона.Ссылка КАК Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПоляФормШаблонов.Ссылка КАК Ссылка,
		|		ПоляФормШаблонов.ПометкаУдаления КАК ПометкаУдаления
		|	ИЗ
		|		Справочник.ЕАС_ПоляФормШаблонов КАК ПоляФормШаблонов
		|	ГДЕ
		|		ПоляФормШаблонов.Владелец = &Шаблон) КАК ВсеПоляШаблона
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕАС_ПоляФормШаблонов КАК ПоляФормШаблонов
		|		ПО ВсеПоляШаблона.Ссылка = ПоляФормШаблонов.Ссылка
		|			И (ПоляФормШаблонов.Ссылка В (&МассивСсылок))
		|ГДЕ
		|	ПоляФормШаблонов.Ссылка ЕСТЬ NULL
		|	И НЕ ВсеПоляШаблона.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("Шаблон",       Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Блокировка = Новый БлокировкаДанных;
		Пока РезультатЗапроса.Следующий() Цикл
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ЕАС_ПоляФормШаблонов");
			ЭлементБлокировки.Режим=РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", РезультатЗапроса.Ссылка);
		КонецЦикла;	
		Блокировка.Заблокировать();
		
		РезультатЗапроса.Сбросить();
		Пока РезультатЗапроса.Следующий() Цикл
			ПолеОбъект = РезультатЗапроса.Ссылка.ПолучитьОбъект();
			ПолеОбъект.Удалить();            
		КонецЦикла;	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	МассивПримитивныхТипов = СтрРазделить("Строка,Число,Дата,Граница,Булево", ",");
	СписокПримитивныхТипов = Новый СписокЗначений;
	СписокПримитивныхТипов.ЗагрузитьЗначения(МассивПримитивныхТипов);
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();     
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыЗаполненияТипУточнение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПараметрыЗаполнения.ТипВФорме");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПримитивныхТипов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();     
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПараметрыЗаполненияТипУточнение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПараметрыЗаполнения.ТипВФорме");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПримитивныхТипов;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПараметрыЗаполнения.ТипУточнениеВФорме");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

#КонецОбласти
