# pine_tree.py to .deb file

### Update 01.12.23
- Создан dockerfile с необходимыми библиотеками
- Вернулась ошибка ``dpkg-buildpackage: error: version number does not start with digit``

### Создание и запуск контейнера
- Загузка последней версии image debian:\
   ``docker pull debian``
- Запуск контейнера с достуом к bash и монтируем локальную директорию в контейнер\
 ``docker run -it -v D:\dock_mount:/mounted debian /bin/bash``

### Создаем нужные директории
- Создаем директорию для пакета (формат: название_проекта-весия):\
``mkdir pine_tree-0.1``
- Cоздаем директорию необходимых для созданияя .deb пакета исходников с зависимостями:\
  ``mkdir pine_tree-0.1/debian``

### Доустанавливаем нужные пакеты:
``apt-get update`` \
``apt-get install dpkg-dev devscripts wget`` 

Я нашла 3 варианта созданя нужных исходных файлов:
1. создать по формату changelog используя: \
   ``dch --create``\
и прописать\создать остальные файлы вучную (необходимые: copyright, compat, rules, control, install) \
*(У меня чеез эту команду не подхватывались необходимые данные о поекте и создателе, смена вручную не помогла)*

2. создать "скелет" директори (debian/* ) через \
``dh_make -s --indep --createorig`` \
и заменить файлы-примеры своими с нужными данными \
*(Возникла проблема с установкой dh_make. Так же debuild --no-tgz-check не реагировала на вручную созданные файлы debian/ * : \
dpkg-buildpackage: error: version number does not start with digit \
debuild: fatal error at line 1182: \
dpkg-buildpackage -us -uc -ui failed)*

3. использовать cookiecutter, который по введенным данным создает корректные файлы с зависимостями: \
``apt install cookiecutter`` \
Запускается из директории с файлом (pine_tree-0.1) (предварительно необходимо удалить старую директорию debian/* т.к. cookiecutter создает ее снова полностью): \
``cookiecutter https://github.com/Springerle/dh-virtualenv-mold.git`` \
Как выглядит в консоли заполнение данных: 
```
You've downloaded /root/.cookiecutters/dh-virtualenv-mold before. Is it okay to delete and re-download it? [yes]: yes
full_name [Joe Schmoe]: Arctic-gray
email [you@example.com]: vik.teplowa2012@yandex.ru
url [https://github.com/jschmoe/foobar]: https://github.com/Arctic-gray/pine_tree
package [pyvenv-foobar]: pine_tree
version [0.1.0]: 0.1.0
distro [UNRELEASED]: UNRELEASED
year [2020]: 2023
short_description [A Python package and its dependencies packaged up as DEB in an isolated virtualenv.]: Simple pyton package
repo_name [debian]: debian
snake [/usr/bin/python3]: /usr/bin/python3``
```
Из этих данных создается полноценнный набор файлов с зависимостями в debian/* : \
![image](https://github.com/Arctic-gray/pine_tree/assets/129815345/22a78a9a-2d2b-4526-982e-20e1b252bd59)

#### Возникшие ошибки:
**Испавлено** \
При добавлении недостающей зависимости: \
``mk-build-deps --install debian/control`` \
Возващается ошибка: \
``dpkg-buildpackage: error: version number does not start with digit`` , \
которая возникает во всех новых версиях dpkg (по найденной информациии)
*(испавляется откатом к старой версии dpkg --force-downgrade -i /mounted/dpkg_1.15.8.13_amd64.deb, грубый, но быстрый вариант)*

### Текущие ошибки:
**Соханяется ошибка:** \
``dpkg-architecture: error: cannot open tupletable: No such file or directory`` \
Возможные причины: с директорией ошибки нет, скорее всего связано с несогласованностью версий

### В теории осталось:
- Исправить ошибку
- Обновить нужную зависимость: \
``mk-build-deps --install debian/control`` 
- Запустить билд: \
``dpkg-buildpackage -uc -us -b``
