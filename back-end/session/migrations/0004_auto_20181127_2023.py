# Generated by Django 2.1.3 on 2018-11-27 17:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('session', '0003_session'),
    ]

    operations = [
        migrations.CreateModel(
            name='EnterSession',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('session_id', models.TextField(max_length=255)),
                ('Player_NickName', models.TextField(max_length=255)),
            ],
        ),
        migrations.AddField(
            model_name='session',
            name='is_provided',
            field=models.BooleanField(default=False),
        ),
    ]
