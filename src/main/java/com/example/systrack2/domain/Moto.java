package com.example.systrack2.domain;

import com.example.systrack2.domain.enums.Status;
import jakarta.persistence.*;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Moto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    @Pattern(
            regexp = "^[A-Z]{3}-[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$",
            message = "Placa inválida. Use o formato XXX-1234 ou XXX1X23."
    )
    private String placa;

    private String modelo;

    private int ano;

    private Double quilometragem;

    @Enumerated(EnumType.STRING)
    private Status status;  //(FUNCIONAL, MANUTENCAO)

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "patio_id")
    private Patio patio;
}
