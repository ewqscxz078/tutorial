package tw.gov.moi.aw3.bg.db.popudata.model;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.*;

/**
 * The persistent class for the popuctrl_acc database table.
 *
 */
@Entity
@Table(name = "popuctrl_acc")
//@NamedQuery(name="PopuctrlAcc.findAll", query="SELECT p FROM PopuctrlAcc p")
public class PopuctrlAcc implements Serializable {

    private static final long serialVersionUID = 1L;

    // primary key serialCode[DB自動給數值]
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "serial_code") // , nullable = false
    private Long serialCode;

    private String adddate;

    private String addid;

    private String ischart;

    private String isdel;

    private String ism4c;

    private String ismngm;

    private String isrowmeta;

    private String issrc;

    @Column(name = "lst_acs_dtm")
    private String lstAcsDtm;

    private String srvccode;

    private String userid;

    private String username;

    public PopuctrlAcc() {
    }

    public String getAdddate() {
        return this.adddate;
    }

    public void setAdddate(final String adddate) {
        this.adddate = adddate;
    }

    public String getAddid() {
        return this.addid;
    }

    public void setAddid(final String addid) {
        this.addid = addid;
    }

    public String getIschart() {
        return this.ischart;
    }

    public void setIschart(final String ischart) {
        this.ischart = ischart;
    }

    public String getIsdel() {
        return this.isdel;
    }

    public void setIsdel(final String isdel) {
        this.isdel = isdel;
    }

    public String getIsm4c() {
        return this.ism4c;
    }

    public void setIsm4c(final String ism4c) {
        this.ism4c = ism4c;
    }

    public String getIsmngm() {
        return this.ismngm;
    }

    public void setIsmngm(final String ismngm) {
        this.ismngm = ismngm;
    }

    public String getIsrowmeta() {
        return this.isrowmeta;
    }

    public void setIsrowmeta(final String isrowmeta) {
        this.isrowmeta = isrowmeta;
    }

    public String getIssrc() {
        return this.issrc;
    }

    public void setIssrc(final String issrc) {
        this.issrc = issrc;
    }

    public String getLstAcsDtm() {
        return this.lstAcsDtm;
    }

    public void setLstAcsDtm(final String lstAcsDtm) {
        this.lstAcsDtm = lstAcsDtm;
    }

    public Long getSerialCode() {
        return this.serialCode;
    }

    public void setSerialCode(final Long serialCode) {
        this.serialCode = serialCode;
    }

    public String getSrvccode() {
        return this.srvccode;
    }

    public void setSrvccode(final String srvccode) {
        this.srvccode = srvccode;
    }

    public String getUserid() {
        return this.userid;
    }

    public void setUserid(final String userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(final String username) {
        this.username = username;
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.serialCode);
    }

    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final PopuctrlAcc other = (PopuctrlAcc) obj;
        return this.serialCode == other.serialCode;
    }

    @Override
    public String toString() {
        return "PopuctrlAcc [adddate=" + this.adddate + ", addid=" + this.addid + ", ischart=" + this.ischart + ", isdel="
                + this.isdel + ", ism4c=" + this.ism4c + ", ismngm=" + this.ismngm + ", isrowmeta=" + this.isrowmeta + ", issrc="
                + this.issrc + ", lstAcsDtm=" + this.lstAcsDtm + ", serialCode=" + this.serialCode + ", srvccode=" + this.srvccode
                + ", userid=" + this.userid + ", username=" + this.username + "]";
    }

}