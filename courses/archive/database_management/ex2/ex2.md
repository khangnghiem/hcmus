### ER Diagram
```mermaid
erDiagram
    PATIENT {
        int patient_id PK
        string name
        date birth_date
        date admission_date
        string patient_type
        date follow_up_date
        date discharge_date
    }
    DOCTOR {
        int doctor_id PK
        string name
        date birth_date
        date hire_date
        float salary
    }
    ROOM {
        string room_id PK
        string room_type
        float room_price
        string building
        int floor
    }
    INPATIENT {
        int patient_id PK, FK
        string room_id FK
    }
    OUTPATIENT {
        int patient_id PK, FK
    }
    PATIENT ||--o{ DOCTOR: "treated by"
    DOCTOR ||--o{ PATIENT: "treats"
    ROOM ||--o{ INPATIENT: "assigned to"
    INPATIENT ||--|| PATIENT: "is a"
    OUTPATIENT ||--|| PATIENT: "is a"
```

### Relational Schema

**PATIENT (patient_id, name, birth_date, admission_date, patient_type, follow_up_date, discharge_date)**

**DOCTOR (doctor_id, name, birth_date, hire_date, salary)**

**ROOM (room_id, room_type, room_price, building, floor)**

**INPATIENT (patient_id, room_id)**

**OUTPATIENT (patient_id)**

- Each `PATIENT` is treated by one or more `DOCTOR`.
- Each `DOCTOR` can treat zero or more `PATIENT`.
- Each `INPATIENT` is assigned to one `ROOM`.
- Each `ROOM` can have zero or more `INPATIENT`.
- Each `PATIENT` can be either an `INPATIENT` or an `OUTPATIENT`.
```