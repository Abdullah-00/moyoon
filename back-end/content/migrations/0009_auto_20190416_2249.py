# Generated by Django 2.1.3 on 2019-04-16 19:49

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('content', '0008_auto_20190416_2248'),
    ]

    operations = [
        migrations.AlterField(
            model_name='questiontmp',
            name='Category_parent',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='content.Category'),
        ),
    ]
