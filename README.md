# Ansible role of Windows-exporter

Ansible проект для автоматической установки и настройки Windows Exporter на Windows серверах для мониторинга с помощью Prometheus.

## Описание

Этот проект содержит Ansible роль `windows-exporter`, которая автоматизирует процесс установки, настройки и управления Windows Exporter на Windows серверах. Windows Exporter собирает системные метрики Windows и предоставляет их в формате, совместимом с Prometheus.

## Структура проекта

```
windows_server_ansible/
├── inventory.yml                           # Инвентарь серверов
├── playbook.yml                           # Основной плейбук
└── roles/
    └── windows-exporter/
        ├── defaults/
        │   └── main.yml                   # Переменные по умолчанию
        ├── handlers/
        │   └── main.yml                   # Обработчики событий
        └── tasks/
            └── main.yml                   # Основные задачи роли
```

## Возможности

- ✅ Автоматическая загрузка и установка Windows Exporter
- ✅ Проверка версий и обновление при необходимости
- ✅ Настройка параметров запуска (адрес, порт, директория текстовых файлов)
- ✅ Автоматическая настройка правил брандмауэра Windows
- ✅ Управление службой Windows Exporter
- ✅ Проверка корректности конфигурации

## Требования

### Управляющий узел (Control Node)

- Ansible 2.9+
- Python 3.6+
- Модуль `ansible.windows`

### Целевые серверы (Windows)

- Windows Server 2012 R2 / Windows 10 или новее
- PowerShell 3.0+
- WinRM настроен и доступен (запустите с правами администратора winrm_configuration.ps1)
- .NET Framework 4.5+

## Установка зависимостей

```bash
# Установка коллекции ansible.windows
ansible-galaxy collection install ansible.windows

# Установка дополнительных зависимостей Python
pip install pywinrm
```

## Настройка

### 1. Конфигурация инвентаря

Отредактируйте файл `inventory.yml`:

```yaml
windows:
  hosts:
    ms-server1:
      ansible_host: 192.168.1.100
      ansible_user: your_username
      ansible_password: "your_password"
      ansible_connection: winrm
      ansible_winrm_transport: basic
      ansible_winrm_server_cert_validation: ignore
      ansible_port: 5985
    ms-server2:
      ansible_host: 192.168.1.101
      ansible_user: your_username
      ansible_password: "your_password"
      ansible_connection: winrm
      ansible_winrm_transport: basic
      ansible_winrm_server_cert_validation: ignore
      ansible_port: 5985
```

### 2. Настройка переменных роли

Основные переменные в `roles/windows-exporter/defaults/main.yml`:

| Переменная | Значение по умолчанию | Описание |
|------------|----------------------|----------|
| `windows_exporter_version` | `0.30.7` | Версия Windows Exporter |
| `windows_exporter_arch` | `amd64` | Архитектура (amd64/386) |
| `windows_exporter_listen_address` | `0.0.0.0` | IP адрес для прослушивания |
| `windows_exporter_listen_port` | `9182` | Порт для прослушивания |
| `windows_exporter_state` | `started` | Состояние службы |
| `windows_exporter_start_mode` | `delayed` | Режим запуска службы |
| `windows_exporter_allow_from` | `any` | Разрешенные IP для брандмауэра |
| `windows_exporter_textfile_dir` | `null` | Директория для текстовых метрик |

## Использование

### Запуск плейбука

```bash
# Запуск на всех хостах
ansible-playbook -i inventory.yml playbook.yml

# Запуск на конкретном хосте
ansible-playbook -i inventory.yml playbook.yml --limit ms-server1

# Проверка без выполнения изменений
ansible-playbook -i inventory.yml playbook.yml --check
```

**Примечание:** Убедитесь, что у вас есть соответствующие права доступа к целевым Windows серверам и что WinRM правильно настроен (для настройки запустите на целевом сервере winrm_configuration.ps1) перед запуском плейбука.
