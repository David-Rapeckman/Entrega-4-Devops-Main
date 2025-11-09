package com.example.systrack2.DTO.Request;

import lombok.Data;

@Data
public class MotoFiltroDTO {
    private String modelo;
    private Integer ano;
    private Integer quilometragemExata;
    private Integer quilometragemMin;
    private Integer quilometragemMax;
    private String status;
}
