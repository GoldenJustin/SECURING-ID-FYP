# Generated by Django 2.2.18 on 2023-06-01 22:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('login', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Student',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=255)),
                ('email', models.EmailField(max_length=255)),
                ('password', models.CharField(max_length=50)),
                ('programme', models.CharField(max_length=50)),
                ('registrationNumber', models.CharField(max_length=25, unique=True)),
                ('signature', models.ImageField(upload_to='')),
                ('token', models.CharField(default='', max_length=500, null=True)),
            ],
        ),
        migrations.DeleteModel(
            name='User',
        ),
    ]
