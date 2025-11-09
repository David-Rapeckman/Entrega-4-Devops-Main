package com.example.systrack2.DTO.Request;

import com.example.systrack2.domain.enums.Status;
import lombok.Data;

@Data
public class MotoRequestDTO {
    private Long id;
    private String placa;
    private String modelo;
    private Long usuarioId;
    private Long patioId;
    private int ano;
    private double quilometragem;
    private Status status;
}